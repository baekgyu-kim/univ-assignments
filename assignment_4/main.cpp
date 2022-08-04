#include <time.h> /* clock_t, clock, CLOCKS_PER_SEC */

#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <iostream>

#include "AVLTree.h"
#include "LinkedBinaryTree.h"
#include "SearchTree.h"

int main() {
    typedef Entry<int, float> EntryType;
    LinkedBinaryTree<EntryType> t;
    std::cout << "Size : " << t.size() << std::endl;
    t.addRoot();
    std::cout << "Size : " << t.size() << std::endl;
    SearchTree<EntryType> st;
    std::cout << "Size : " << st.size() << std::endl;
    st.insert(1, 2.5);
    st.insert(3, 4.5);
    st.insert(7, 5.5);
    st.insert(2, 1.5);
    st.insert(3, 8.5);
    std::cout << "Size : " << st.size() << std::endl;
    for (SearchTree<EntryType>::Iterator it = st.begin(); it != st.end();
         ++it) {
        std::cout << (*it).key() << " , " << (*it).value() << std::endl;
    }
    st.erase(3);
    std::cout << "Size : " << st.size() << std::endl;
    for (SearchTree<EntryType>::Iterator it = st.begin(); it != st.end();
         ++it) {
        std::cout << (*it).key() << " , " << (*it).value() << std::endl;
    }
    std::cout << "------------" << std::endl;

    //
    clock_t tm;

    {
        SearchTree<EntryType> bst1;
        AVLTree<EntryType> avl1;
        SearchTree<EntryType> bst2;
        AVLTree<EntryType> avl2;

        int nElem = 10;
        std::cout << "n  = " << nElem << std::endl;
        int *key_rand = new int[nElem];
        int *key_skewed = new int[nElem];
        std::srand(std::time(0));
        for (int i = 0; i < nElem; i++) {
            key_rand[i] = std::rand();
            key_skewed[i] = std::rand();
        }
        sort(key_skewed, key_skewed + nElem);
        std::cout << "For Random Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst1.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl1.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst1.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl1.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "\nFor Skewed Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst2.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl2.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst2.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl2.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        std::cout << "\n" << std::endl;
    }
    {
        SearchTree<EntryType> bst3;
        AVLTree<EntryType> avl3;
        SearchTree<EntryType> bst4;
        AVLTree<EntryType> avl4;

        int nElem = 100;
        std::cout << "n  = " << nElem << std::endl;
        int *key_rand = new int[nElem];
        int *key_skewed = new int[nElem];
        std::srand(std::time(0));
        for (int i = 0; i < nElem; i++) {
            key_rand[i] = std::rand();
            key_skewed[i] = std::rand();
        }
        sort(key_skewed, key_skewed + nElem);
        std::cout << "For Random Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst3.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl3.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst3.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl3.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "\nFor Skewed Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst4.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl4.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst4.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl4.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        std::cout << "\n" << std::endl;
    }
    {
        SearchTree<EntryType> bst5;
        AVLTree<EntryType> avl5;
        SearchTree<EntryType> bst6;
        AVLTree<EntryType> avl6;

        int nElem = 1000;
        std::cout << "n  = " << nElem << std::endl;
        int *key_rand = new int[nElem];
        int *key_skewed = new int[nElem];
        std::srand(std::time(0));
        for (int i = 0; i < nElem; i++) {
            key_rand[i] = std::rand();
            key_skewed[i] = std::rand();
        }
        sort(key_skewed, key_skewed + nElem);
        std::cout << "For Random Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst5.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl5.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst5.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl5.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "\nFor Skewed Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst6.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl6.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst6.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl6.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        std::cout << "\n" << std::endl;
    }
    {
        SearchTree<EntryType> bst1;
        AVLTree<EntryType> avl1;
        SearchTree<EntryType> bst2;
        AVLTree<EntryType> avl2;

        int nElem = 10000;
        std::cout << "n  = " << nElem << std::endl;
        int *key_rand = new int[nElem];
        int *key_skewed = new int[nElem];
        std::srand(std::time(0));
        for (int i = 0; i < nElem; i++) {
            key_rand[i] = std::rand();
            key_skewed[i] = std::rand();
        }
        sort(key_skewed, key_skewed + nElem);
        std::cout << "For Random Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst1.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl1.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst1.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl1.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "\nFor Skewed Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst2.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl2.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst2.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl2.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        std::cout << "\n" << std::endl;
    }
    {
        SearchTree<EntryType> bst1;
        AVLTree<EntryType> avl1;
        SearchTree<EntryType> bst2;
        AVLTree<EntryType> avl2;

        int nElem = 100000;
        std::cout << "n  = " << nElem << std::endl;
        int *key_rand = new int[nElem];
        int *key_skewed = new int[nElem];
        std::srand(std::time(0));
        for (int i = 0; i < nElem; i++) {
            key_rand[i] = std::rand();
            key_skewed[i] = std::rand();
        }
        sort(key_skewed, key_skewed + nElem);
        std::cout << "For Random Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst1.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl1.insert(key_rand[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst1.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl1.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "\nFor Skewed Input" << std::endl;
        std::cout << "---INSERT---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst2.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl2.insert(key_skewed[i], 0);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;

        std::cout << "---FIND---" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            bst2.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "BST : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        tm = clock();
        for (int i = 0; i < nElem; i++) {
            avl2.find(key_rand[i]);
        }
        tm = clock() - tm;
        std::cout << "AVL : " << ((float)tm) / (float)CLOCKS_PER_SEC
                  << " seconds" << std::endl;
        std::cout << "\n" << std::endl;
    }
    return 0;
}