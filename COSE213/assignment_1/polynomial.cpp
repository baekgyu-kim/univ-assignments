#include "polynomial.h"

#include <math.h>

#include <iostream>

//
// Implementation
//

// Copy constructor
Polynomial::Polynomial(const Polynomial& source) {
    capacity = source.capacity;
    terms = source.terms;
    termArray = new Term[capacity];
    for (int i = 0; i < terms; i++) {
        termArray[i].coef = source.termArray[i].coef;
        termArray[i].exp = source.termArray[i].exp;
    }
    // 내림차순 정렬(Bubble Sort)
    for (int i = 0; i < terms; i++) {
        for (int j = 0; j < terms - i - 1; j++) {
            if (termArray[j].exp < termArray[j + 1].exp) {
                float tempCoef = termArray[j].coef;
                int tempExp = termArray[j].exp;
                termArray[j].coef = termArray[j + 1].coef;
                termArray[j].exp = termArray[j + 1].exp;
                termArray[j + 1].coef = tempCoef;
                termArray[j + 1].exp = tempExp;
            }
        }
    }
}

// Destructor
Polynomial::~Polynomial() { delete[] termArray; }

Polynomial& Polynomial::operator=(const Polynomial& source) {
    capacity = source.capacity;
    terms = source.terms;
    termArray = new Term[capacity];
    for (int i = 0; i < terms; i++) {
        termArray[i].coef = source.termArray[i].coef;
        termArray[i].exp = source.termArray[i].exp;
    }
    // 내림차순 정렬(Bubble Sort)
    for (int i = 0; i < terms; i++) {
        for (int j = 0; j < terms - i - 1; j++) {
            if (termArray[j].exp < termArray[j + 1].exp) {
                float tempCoef = termArray[j].coef;
                int tempExp = termArray[j].exp;
                termArray[j].coef = termArray[j + 1].coef;
                termArray[j].exp = termArray[j + 1].exp;
                termArray[j + 1].coef = tempCoef;
                termArray[j + 1].exp = tempExp;
            }
        }
    }
    return *this;
}

// Sum of *this and source polynomials
Polynomial Polynomial::operator+(const Polynomial& source) {
    Polynomial c;
    int index = 0;
    int i = 0;
    int j = 0;
    float left_coef, right_coef;
    int left_exp, right_exp;
    while (i < terms && j < source.terms) {
        left_coef = termArray[i].coef;
        right_coef = source.termArray[j].coef;
        left_exp = termArray[i].exp;
        right_exp = source.termArray[j].exp;
        if (left_exp > right_exp) {
            if (index > c.capacity - 1) {
                c.CreateTerm(left_coef, left_exp);
                index += 1;
                i += 1;
            } else {
                c.termArray[index].coef = left_coef;
                c.termArray[index].exp = left_exp;
                index += 1;
                i += 1;
                c.terms += 1;
            }

        } else if (left_exp < right_exp) {
            if (index > c.capacity - 1) {
                c.CreateTerm(right_coef, right_exp);
                index += 1;
                j += 1;
            } else {
                c.termArray[index].coef = right_coef;
                c.termArray[index].exp = right_exp;
                index += 1;
                j += 1;
                c.terms += 1;
            }

        } else {
            //더했을 때 coef 0이 되는 경우
            if (left_coef + right_coef == 0) {
                i += 1;
                j += 1;
            } else {
                if (index > c.capacity - 1) {
                    c.CreateTerm(left_coef + right_coef, left_exp);
                    index += 1;
                    i += 1;
                    j += 1;
                } else {
                    c.termArray[index].coef = left_coef + right_coef;
                    c.termArray[index].exp = left_exp;
                    index += 1;
                    i += 1;
                    j += 1;
                    c.terms += 1;
                }
            }
        }
    }
    return c;
}

Polynomial Polynomial::operator-(const Polynomial& source) {
    Polynomial c;
    int index = 0;
    int i = 0;
    int j = 0;
    float left_coef, right_coef;
    int left_exp, right_exp;
    while (i < terms && j < source.terms) {
        left_coef = termArray[i].coef;
        right_coef = source.termArray[j].coef;
        left_exp = termArray[i].exp;
        right_exp = source.termArray[j].exp;
        if (left_exp > right_exp) {
            if (index > c.capacity - 1) {
                c.CreateTerm(left_coef, left_exp);
                index += 1;
                i += 1;
            } else {
                c.termArray[index].coef = left_coef;
                c.termArray[index].exp = left_exp;
                index += 1;
                i += 1;
                c.terms += 1;
            }
        } else if (left_exp < right_exp) {
            if (index > c.capacity - 1) {
                c.CreateTerm(-(right_coef), right_exp);
                index += 1;
                j += 1;
            } else {
                c.termArray[index].coef = -(right_coef);
                c.termArray[index].exp = right_exp;
                index += 1;
                j += 1;
                c.terms += 1;
            }
        } else {
            //뺐을 때 coef가 0이 되는 경우
            if (left_coef == right_coef) {
                i += 1;
                j += 1;
            } else {
                if (index > c.capacity - 1) {
                    c.CreateTerm(left_coef - right_coef, left_exp);
                    index += 1;
                    i += 1;
                    j += 1;
                } else {
                    c.termArray[index].coef = left_coef - right_coef;
                    c.termArray[index].exp = left_exp;
                    index += 1;
                    i += 1;
                    j += 1;
                    c.terms += 1;
                }
            }
        }
    }
    return c;
}

Polynomial Polynomial::operator*(const Polynomial& source) {
    Polynomial c;
    int index = 0;
    //모든 항 분배해서 전개하기
    for (int i = 0; i < terms; i++) {
        for (int j = 0; j < source.terms; j++) {
            float left_coef = termArray[i].coef;
            float right_coef = source.termArray[j].coef;
            int left_exp = termArray[i].exp;
            int right_exp = source.termArray[j].exp;
            if (index > c.capacity - 1) {
                c.CreateTerm(left_coef * right_coef, left_exp + right_exp);
                index += 1;
            } else {
                c.termArray[index].coef = left_coef * right_coef;
                c.termArray[index].exp = left_exp + right_exp;
                index += 1;
                c.terms += 1;
            }
        }
    }
    // 내림차순 정렬(Bubble Sort)
    for (int i = 0; i < c.terms; i++) {
        for (int j = 0; j < c.terms - i - 1; j++) {
            if (c.termArray[j].exp < c.termArray[j + 1].exp) {
                float tempCoef = c.termArray[j].coef;
                int tempExp = c.termArray[j].exp;
                c.termArray[j].coef = c.termArray[j + 1].coef;
                c.termArray[j].exp = c.termArray[j + 1].exp;
                c.termArray[j + 1].coef = tempCoef;
                c.termArray[j + 1].exp = tempExp;
            }
        }
    }

    //앞뒤로 차수가 같은 항 하나의 항으로 합치기
    for (int i = 0; i < c.terms; i++) {
        for (int j = 0; j < c.terms - i - 1; j++) {
            if (c.termArray[j].exp == c.termArray[j + 1].exp) {
                c.termArray[j].coef =
                    c.termArray[j].coef + c.termArray[j + 1].coef;
                c.termArray[j + 1].coef = 0;
                c.termArray[j + 1].exp = 0;
            }
        }
    }
    // coef가 0인 항들 제거하기 위해 일단 맨 뒤로 이동시키기
    for (int i = 0; i < c.terms; i++) {
        if (c.termArray[i].coef == 0) {
            for (int j = i; j < c.terms - 1; j++) {
                c.termArray[j].coef = c.termArray[j + 1].coef;
                c.termArray[j].exp = c.termArray[j + 1].exp;
            }
        }
    }
    // 0에 대한 정보들을 변수로 정리함
    int first_zero_index = 0;
    for (int i = 0; i < c.terms; i++) {
        if (c.termArray[i].coef == 0) {
            first_zero_index = i;
            break;
        }
    }
    int num_of_zero = c.terms - first_zero_index;
    int final_terms = c.terms - num_of_zero;
    int final_capacity = c.capacity - num_of_zero;

    // newArray 만들어서 0인 항들 제거하기
    Term* newArray = new Term[final_terms];
    for (int i = 0; i < final_terms; i++) {
        newArray[i].coef = c.termArray[i].coef;
        newArray[i].exp = c.termArray[i].exp;
    }
    delete[] c.termArray;
    // newArray 복사해서 termArray 완성
    c.termArray = new Term[final_terms];
    for (int i = 0; i < final_terms; i++) {
        c.termArray[i].coef = newArray[i].coef;
        c.termArray[i].exp = newArray[i].exp;
    }
    delete[] newArray;
    c.terms = final_terms;
    c.capacity = final_capacity;
    return c;
}

bool Polynomial::operator==(const Polynomial& right) {
    bool ret;
    ret = true;
    if (terms != right.terms) {
        ret = false;
    } else {
        for (int i = 0; i < terms; i++) {
            float left_coef = termArray[i].coef;
            float right_coef = right.termArray[i].coef;
            int left_exp = termArray[i].exp;
            int right_exp = right.termArray[i].exp;
            if ((left_coef != right_coef) || (left_exp != right_exp)) {
                ret = false;
            }
        }
    }
    return ret;
}

float Polynomial::Eval(float x) {
    float ret = 0;
    for (int i = 0; i < terms; i++) {
        float temp = 1;
        for (int j = 0; j < termArray[i].exp; j++) {
            temp *= x;
        }
        ret += termArray[i].coef * temp;
    }
    return ret;
}

// Compute derivative of the current polynomial
Polynomial Polynomial::Derivative() {
    Polynomial c;
    for (int i = 0; i < terms; i++) {
        if (termArray[i].exp == 0) {
            continue;
        } else {
            c.termArray[i].coef = termArray[i].coef * termArray[i].exp;
            c.termArray[i].exp = termArray[i].exp - 1;
            c.terms += 1;
        }
    }
    return c;
}

void Polynomial::CreateTerm(const float coef, const int exp) {
    //빈 공간 남아있으면 그냥 빈 자리에 채워넣기
    if (terms < capacity) {
        termArray[terms].coef = coef;
        termArray[terms].exp = exp;
        terms += 1;
    }
    //빈 공간 없으면 newArray 만들어서 공간 하나 추가
    else {
        terms += 1;
        capacity += 1;
        Term* newArray = new Term[terms];
        for (int i = 0; i < terms - 1; i++) {
            newArray[i].coef = termArray[i].coef;
            newArray[i].exp = termArray[i].exp;
        }
        //증가시킨 마지막 공간에 항 추가
        newArray[terms - 1].coef = coef;
        newArray[terms - 1].exp = exp;
        // newArray 복사해서 termArray 완성
        delete[] termArray;
        termArray = new Term[terms];
        for (int j = 0; j < terms; j++) {
            termArray[j].coef = newArray[j].coef;
            termArray[j].exp = newArray[j].exp;
        }
        delete[] newArray;
    }
    // 내림차순 정렬(Bubble Sort)
    for (int i = 0; i < terms; i++) {
        for (int j = 0; j < terms - i - 1; j++) {
            if (termArray[j].exp < termArray[j + 1].exp) {
                float tempCoef = termArray[j].coef;
                int tempExp = termArray[j].exp;
                termArray[j].coef = termArray[j + 1].coef;
                termArray[j].exp = termArray[j + 1].exp;
                termArray[j + 1].coef = tempCoef;
                termArray[j + 1].exp = tempExp;
            }
        }
    }
}
