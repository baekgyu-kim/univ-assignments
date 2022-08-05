#ifndef CALCULATOR_H
#define CALCULATOR_H

//
// Assignment 2 : Simple calculator using Stack
//
// COSE213 Fall 2021
//
// Won-Ki Jeong (wkjeong@korea.ac.kr)
//

#include <math.h>
#include <string.h>

#include <cassert>
#include <iostream>

#include "stack.h"

Stack<double> opr;  // stack for operands
Stack<char> opt;    // stack for operators

int icp(char c);
int isp(char c);
double calculate(char c, double opr1, double opr2);
void handle_opt(char c);

//
// Modify Eval() below to evaluate the given expression
//
double Eval(char* in) {
    double out = 0;
    char buf[1000];  // temp buffer
    char lastToken = '#';
    double operand;
    int i = 0, bi = 0;

    opt.Push('#');

    // Unary Minus를 '~'로 임시로 바꾸기 ('-'연산자와 구분하기 위해서)
    int j = 0;
    while (in[j] != '\0') {
        if (in[j] == '-') {
            if (j == 0) {
                in[j] = '~';
            } else {
                int k = 1;
                while (in[j - k] == ' ') {
                    k += 1;
                }
                if (in[j - k] == '(') {
                    in[j] = '~';
                }
            }
        }
        j += 1;
    }

    while (in[i] != '\0') {
        char c = in[i];

        // Operators
        if (c == '+' || c == '-' || c == '*' || c == '/' || c == '(' ||
            c == ')') {
            if (bi > 0) {
                buf[bi++] = '\0';
                // Unary Munus를 다시 '-'로 되돌리기
                if (buf[0] == '~') {
                    buf[0] = '-';
                }
                operand = atof(buf);
                bi = 0;

                // std::cout << "New operand : " << operand << std::endl;
                opr.Push(operand);
            }

            handle_opt(c);
        }

        else if (c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
                 c == '5' || c == '6' || c == '7' || c == '8' || c == '9' ||
                 c == '.' || c == '~') {
            buf[bi++] = c;
        } else {
        }

        i++;
    }

    // push the very last operand if exists
    if (bi > 0) {
        buf[bi++] = '\0';
        operand = atof(buf);
        bi = 0;
        // std::cout << "New operand : " << operand << std::endl;
        opr.Push(operand);
    }

    while (opt.Top() != '#') {
        double temp1 = opr.Top();
        opr.Pop();
        double temp2 = opr.Top();
        opr.Pop();
        opr.Push(calculate(opt.Top(), temp1, temp2));
        opt.Pop();
    }

    out = opr.Top();

    return out;
}

int icp(char c) {
    int icp_return;
    if (c == '(') {
        icp_return = 0;
    } else if (c == '*' || c == '/') {
        icp_return = 2;
    } else if (c == '+' || c == '-') {
        icp_return = 3;
    }
    return icp_return;
}
int isp(char c) {
    int isp_return;
    if (c == '(') {
        isp_return = 8;
    } else if (c == '*' || c == '/') {
        isp_return = 2;
    } else if (c == '+' || c == '-') {
        isp_return = 3;
    }
    return isp_return;
}
double calculate(char c, double opr1, double opr2) {
    if (c == '+') {
        return opr2 + opr1;
    } else if (c == '-') {
        return opr2 - opr1;
    } else if (c == '*') {
        return opr2 * opr1;
    } else if (c == '/') {
        return opr2 / opr1;
    }
}
void handle_opt(char c) {
    if (c == ')') {
        // std::cout << "New operator : " << c << std::endl;
        if (opt.Top() == '(') {
            opt.Pop();
        } else {
            while (opt.Top() != '(') {
                double temp1 = opr.Top();
                opr.Pop();
                double temp2 = opr.Top();
                opr.Pop();
                opr.Push(calculate(opt.Top(), temp1, temp2));
                opt.Pop();
            }
            opt.Pop();
        }

    } else if ((icp(c) < isp(opt.Top())) || (opt.Top() == '#')) {
        // std::cout << "New operator : " << c << std::endl;
        opt.Push(c);
    } else if (icp(c) >= isp(opt.Top())) {
        // std::cout << "New operator : " << c << std::endl;
        while (icp(c) >= isp(opt.Top())) {
            double temp1 = opr.Top();
            opr.Pop();
            double temp2 = opr.Top();
            opr.Pop();
            opr.Push(calculate(opt.Top(), temp1, temp2));
            opt.Pop();
        }
        opt.Push(c);
    }
}

#endif
