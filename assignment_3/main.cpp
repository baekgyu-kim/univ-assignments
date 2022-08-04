#include <algorithm>
#include <fstream>
#include <iostream>

#include "hashmap.h"

using namespace std;


// HashMap 클래스 객체인 h를 생성
HashMap<MapElem<std::string, int>> h;

void print_suggestion(std::string s) {
    int count = 0;
    int len = s.length();
    int* arr = new int[len];
    char* str = new char[len + 1];
    std::string mystr;
    for (int assign = 0; assign < len; assign++) {
        arr[assign] = (int)s[assign];
    }
    for (int change = 0; change < len; change++) {
        for (int ascii = 97; ascii < 123; ascii++) {
            for (int traverse = 0; traverse < len; traverse++) {
                if (traverse == change) {
                    str[traverse] = (char)ascii;
                    continue;
                }
                str[traverse] = (char)arr[traverse];
            }
            str[len] = '\0';
            //여기까지 오면 char배열 str에 캐릭터 하나 바뀐 스트링 저장됨

            std::string mystr(str);
            if (h.find(mystr) != NULL) {
                std::cout << mystr << " ";
                count += 1;
            }
        }
    }
    if (count == 0) {
        std::cout << "no suggestion";
    }
    std::cout << "" << std::endl;
}

void spellcheck(std::string s) {
    if (h.find(s) != NULL) {
        std::cout << "> " << s << " is in the dictionary" << std::endl;
    } else {
        std::cout << "> " << s << " is NOT in the dictionary" << std::endl;
        std::cout << "> " << s << " : ";
        print_suggestion(s);
    }
}

int main() {
    char filename[] = "dictionary.txt";
    // "dictionary.txt"파일을 읽기 모드로 open해서 ifs라는 ifstream객체를 생성
    std::ifstream ifs(filename, std::ifstream::in);
    // "dictionary.txt"파일 전체의 통짜 string을 s에 저장
    std::string s((std::istreambuf_iterator<char>(ifs)),
                  std::istreambuf_iterator<char>());
    //모든 단어를 소문자로 만듦
    std::transform(s.begin(), s.end(), s.begin(), ::tolower);

    std::string token;
    unsigned int len = s.length();

    for (int i = 0; i < len; i++) {
        int ascii = s[i];
        // string을 돌다가 i번째에서 알파벳이 아닌 캐릭터(공백)을 만났을 때
        if (ascii < 97 || ascii > 127) {
            // token에 저장되어있는게 있으면
            if (token.length() > 0) {
                // ToDo
                // hashmap에 token을 insert함
                h.insert(token, 1);

                // token을 다시 비움
                token.clear();
            }
            continue;
        }
        // token이라는 string에 s의 i번째 캐릭터 append
        token.push_back(s[i]);
    }
    // 마지막 단어 insert 함
    if (token.length() > 0) {
        h.insert(token, 1);
    }

    //
    //사용자가 "q"를 입력할 때까지 계속 input을 받아서 spellcheck함수에 집어넣음
    //
    while (1) {
        std::string s;
        std::cout << "> ";
        std::cin >> s;
        if (s.compare("q") == 0) break;
        spellcheck(s);
    }

    return 0;
}