//
// - Implementation -
//

// destructor
template <class HashMapElemType>
HashMap<HashMapElemType>::HashMap(unsigned int c) {
    mapsize = 0;
    capacity = 997;
    divisor = 997;
    ht = new HashMapElemType*[997];
    for (int i = 0; i < 997; i++) {
        ht[i] = new HashMapElemType[1];
        ht[i]->link = NULL;
    }
}

// destructor
template <class HashMapElemType>
HashMap<HashMapElemType>::~HashMap() {
    for (int i = 0; i < 997; i++) {
        delete[] ht[i];
    }
    delete[] ht;
}

template <class HashMapElemType>
HashMapElemType* HashMap<HashMapElemType>::find(const KeyType k) {
    int bucket = hashfunction(k);
    HashMapElemType* p = ht[bucket];
    while (1) {
        if (p->key == k) {
            return p;
        } else if (p->link == NULL) {
            return NULL;
        }
        p = p->link;
    }
}

template <class HashMapElemType>
void HashMap<HashMapElemType>::insert(const KeyType k, const ValType v) {
    int bucket = hashfunction(k);
    HashMapElemType* p = ht[bucket];
    if (find(k) == NULL) {
        while (1) {
            if (p->link == NULL) {
                break;
            }
            p = p->link;
        }
        HashMapElemType* new_p = new HashMapElemType;
        new_p->key = k;
        new_p->val = v;
        new_p->link = NULL;
        p->link = new_p;
    } else {
        find(k)->val = v;
    }
    mapsize += 1;
}

template <class HashMapElemType>
bool HashMap<HashMapElemType>::remove(const KeyType k) {
    int bucket = hashfunction(k);
    HashMapElemType* before = ht[bucket];
    if (find(k) == NULL) {
        return false;
    } else {
        HashMapElemType* erase = find(k);
        while (1) {
            if (before->link->key == k) {
                break;
            }
            before = before->link;
        }
        before->link = erase->link;
        delete erase;
        mapsize -= 1;
        return true;
    }
}

template <class HashMapElemType>
unsigned int HashMap<HashMapElemType>::hashfunction(const KeyType k) {
    int bucket = 0;
    int k_len = k.length();
    for (int i = 0; i < k_len; i++) {
        bucket += (int)k[i];
    }
    bucket = bucket % 997;
    return bucket;
}

template <class HashMapElemType>
void HashMap<HashMapElemType>::print() {
    for (int i = 0; i < 997; i++) {
        HashMapElemType* p = ht[i];
        while (p->link != NULL) {
            if (p->val != 0) {
                std::cout << "key : " << p->key << " "
                          << "value : " << p->val << std::endl;
            }
            p = p->link;
        }
        if (p->val != 0) {
            std::cout << "key : " << p->key << " "
                      << "value : " << p->val << std::endl;
        }
    }
}