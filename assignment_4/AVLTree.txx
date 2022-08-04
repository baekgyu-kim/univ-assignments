//
// Implementation
//
template <typename E>  // constructor
AVLTree<E>::AVLTree() : ST() {}

template <typename E>  // node height utility
int AVLTree<E>::height(const TPos& v) const {
    return (v.isExternal() ? 0 : (*v).height());
}

template <typename E>  // set height utility
void AVLTree<E>::setHeight(TPos v) {
    int hl = height(v.left());
    int hr = height(v.right());
    (*v).setHeight(1 + std::max(hl, hr));  // max of left & right
}

template <typename E>  // is v balanced?
bool AVLTree<E>::isBalanced(const TPos& v) const {
    int bal = height(v.left()) - height(v.right());
    return ((-1 <= bal) && (bal <= 1));
}

template <typename E>  // get tallest grandchild
typename AVLTree<E>::TPos AVLTree<E>::tallGrandchild(const TPos& z) const {
    TPos zl = z.left();
    TPos zr = z.right();
    if (height(zl) >= height(zr))  // left child taller
        if (height(zl.left()) >= height(zl.right()))
            return zl.left();
        else
            return zl.right();
    else  // right child taller
        if (height(zr.right()) >= height(zr.left()))
            return zr.right();
        else
            return zr.left();
}

//
// ToDo
//

template <typename E>  // remove key k entry
void AVLTree<E>::erase(const K& k) {
    TPos v = ST::finder(k, ST::root());
    if (Iterator(v) == ST::end()) {
        return;
    }
    TPos w = eraser(v);
    rebalance(w);
}

template <typename E>  // insert (k,x)
typename AVLTree<E>::Iterator AVLTree<E>::insert(const K& k, const V& x) {
    TPos v = ST::inserter(k, x);
    setHeight(v);
    rebalance(v);
    return Iterator(v);
}

template <typename E>  // rebalancing utility
void AVLTree<E>::rebalance(const TPos& v) {
    TPos z = v;
    while (!(z == ST::root())) {
        z = z.parent();
        setHeight(z);
        if (!isBalanced(z)) {
            TPos x = tallGrandchild(z);
            TPos y = x.parent();
            int x_key = (*x).key();
            int y_key = (*y).key();
            int z_key = (*z).key();
            TPos b = restructure(x);
            TPos a = b.left();
            TPos c = b.right();
            if (a.isExternal() == true && c.isExternal() == true) {
                (*a).setHeight(1);
                (*c).setHeight(1);
                setHeight(b);
            } else if (a.isExternal() == true && c.isExternal() == false) {
                (*a).setHeight(1);
                setHeight(c);
                setHeight(b);
            } else if (a.isExternal() == false && c.isExternal() == true) {
                setHeight(a);
                (*c).setHeight(1);
                setHeight(b);
            } else {
                setHeight(a);
                setHeight(b);
                setHeight(c);
            }
        }
    }
}

template <typename E>  // Binary Search Tree Rotation
typename AVLTree<E>::TPos AVLTree<E>::restructure(const TPos& v) {
    TPos x = v;
    TPos y = x.parent();
    TPos z = y.parent();
    TPos z_par = z.parent();
    bool is_z_leftchild = false;
    if (z_par.left() == z) {
        is_z_leftchild = true;
    }
    int x_key = (*x).key();
    int y_key = (*y).key();
    int z_key = (*z).key();
    if (x_key >= y_key >= z_key) {
        z.right() = y.left();
        y.left() = z;
        if (is_z_leftchild) {
            z_par.left() = y;
        } else {
            z_par.right() = y;
        }
        return y;
    } else if (z_key >= y_key >= x_key) {
        z.left() = y.right();
        y.right() = z;
        if (is_z_leftchild) {
            z_par.left() = y;
        } else {
            z_par.right() = y;
        }
        return y;
    } else if (y_key >= x_key >= z_key) {
        z.right() = x.left();
        x.left() = z;
        y.left() = x.right();
        x.right() = y;
        if (is_z_leftchild) {
            z_par.left() = x;
        } else {
            z_par.right() = x;
        }
        return x;
    } else {
        z.left() = x.right();
        x.right() = z;
        y.right() = x.left();
        x.left() = y;
        if (is_z_leftchild) {
            z_par.left() = x;
        } else {
            z_par.right() = x;
        }
        return x;
    }
}