//
// Assignment 2 : Simple calculator using Stack
//
// Array-based stack data structure
//
// COSE213 Fall 2021
//

template <class type>
Stack<type>::~Stack() {
    delete[] array;
}

template <class type>
type& Stack<type>::Top() {
    if (IsEmpty()) {
        throw "Error: Stack is empty";
    }
    return array[top];
}

template <class type>
void Stack<type>::Push(const type& item) {
    //빈 공간 남아있으면 빈 자리에 넣기
    if (top < capacity - 1) {
        top += 1;
        array[top] = item;
    }
    //빈 공간 없으면 공간 만들어서 넣기
    else {
        capacity *= 2;
        type* newArray = new type[capacity];
        for (int i = 0; i <= top; i++) {
            newArray[i] = array[i];
        }
        top += 1;
        newArray[top] = item;
        delete[] array;
        type* array = new type[capacity];
        for (int i = 0; i <= top; i++) {
            array[i] = newArray[i];
        }
        delete[] newArray;
    }
}

template <class type>
void Stack<type>::Pop() {
    if (IsEmpty()) {
        throw "Error: Stack is empty";
    }
    top -= 1;
}

template <class type>
bool Stack<type>::IsEmpty() const {
    if (top >= 0) {
        return false;
    }
    return true;
}
