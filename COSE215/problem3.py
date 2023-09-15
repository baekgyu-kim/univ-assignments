import re
import nltk


def return_description_list(html_list):
    # 각각의 html 파일에 대해서 description을 찾아서 리스트로 모아 리턴합니다.
    description_list = []
    pattern_description = r'<p data-testid="vuln-description">(.*?)(<\/p>|\n)'
    regex_description = re.compile(pattern_description, re.DOTALL)

    for i in range(len(html_list)):
        html_lines = html_list[i]
        for j in range(len(html_lines)):
            html_sentence = html_lines[j]
            if re.search(regex_description, html_sentence):
                description = re.search(
                    regex_description, html_sentence).group(1)
                description_list.append(description)
    return description_list


def return_tagged_list(description_list):
    # 각각의 description_liset들을 모아 태깅을 한 후 하나의 리스트로 모아 리턴합니다.
    nltk.download('punkt')
    nltk.download("averaged_perceptron_tagger")

    tagged_list = []
    integrated_tagged_list = []

    for i in range(len(description_list)):
        description = description_list[i]
        tokens = nltk.word_tokenize(description)
        tagged = nltk.pos_tag(tokens)
        tagged_list.append(tagged)

    for i in range(len(tagged_list)):
        tagged_line = tagged_list[i]
        for j in range(len(tagged_line)):
            tagged_word = tagged_line[j]
            integrated_tagged_list.append(tagged_word)

    return integrated_tagged_list


def return_noun_list(tagged_list):
    # tagged_list에서 명사만 추출하여 리스트로 리턴합니다.
    noun_list = []
    for i in range(len(tagged_list)):
        tagged_word = tagged_list[i]
        noun_tag = ['NN', 'NNS', 'NNP', 'NNPS']
        if tagged_word[1] in noun_tag:
            noun_list.append(tagged_word)
    return noun_list


def return_verb_list(tagged_list):
    # tagged_list에서 동사만 추출하여 리스트로 리턴합니다.
    verb_list = []
    for i in range(len(tagged_list)):
        tagged_word = tagged_list[i]
        verb_tag = ['VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ']
        if tagged_word[1] in verb_tag:
            verb_list.append(tagged_word)
    return verb_list


def return_noun_dict(noun_list):
    # noun_list를 받아서 각각의 명사들의 빈도수를 딕셔너리로 리턴합니다.
    noun_dict = {}
    for noun in noun_list:
        noun_dict[noun] = noun_dict.get(noun, 0) + 1

    sorted_noun_dict = dict(
        sorted(noun_dict.items(), key=lambda x: x[1], reverse=True))

    return sorted_noun_dict


def return_verb_dict(verb_list):
    # verb_list를 받아서 각각의 동사들의 빈도수를 딕셔너리로 리턴합니다.
    verb_dict = {}
    for verb in verb_list:
        verb_dict[verb] = verb_dict.get(verb, 0) + 1

    sorted_verb_dict = dict(
        sorted(verb_dict.items(), key=lambda x: x[1], reverse=True))

    return sorted_verb_dict


def print_result(noun_dict, verb_dict):
    # noun_dict와 verb_dict를 받아서 종합적으로 상위 10개의 명사와 동사를 출력합니다.
    all_dict = noun_dict
    all_dict.update(verb_dict)
    sorted_all_dict = dict(
        sorted(all_dict.items(), key=lambda x: x[1], reverse=True))
    top_10_items = list(sorted_all_dict.items())[:10]
    for i in range(10):
        word = str(top_10_items[i][0][0])
        count = str(top_10_items[i][1])
        print(str(i+1) + '. '+word + ' - ' + count)


html1 = open('Problem3_html_files/CVE-2014-0160.html', 'r')
html2 = open('Problem3_html_files/CVE-2018-20250.html', 'r')
html3 = open('Problem3_html_files/CVE-2019-0752.html', 'r')
html4 = open('Problem3_html_files/CVE-2020-0688.html', 'r')
html5 = open('Problem3_html_files/CVE-2021-21972.html', 'r')
html6 = open('Problem3_html_files/CVE-2021-26263.html', 'r')
html7 = open('Problem3_html_files/CVE-2021-26947.html', 'r')
html8 = open('Problem3_html_files/CVE-2021-44228.html', 'r')
html9 = open('Problem3_html_files/CVE-2022-48476.html', 'r')
html10 = open('Problem3_html_files/CVE-2023-22577.html', 'r')
html1_lines = html1.readlines()
html2_lines = html2.readlines()
html3_lines = html3.readlines()
html4_lines = html4.readlines()
html5_lines = html5.readlines()
html6_lines = html6.readlines()
html7_lines = html7.readlines()
html8_lines = html8.readlines()
html9_lines = html9.readlines()
html10_lines = html10.readlines()

html_list = [html1_lines, html2_lines, html3_lines, html4_lines, html5_lines,
             html6_lines, html7_lines, html8_lines, html9_lines, html10_lines]

description_list = return_description_list(html_list)

tagged_list = return_tagged_list(description_list)

noun_list = return_noun_list(tagged_list)
verb_list = return_verb_list(tagged_list)

noun_dict = return_noun_dict(noun_list)
verb_dict = return_verb_dict(verb_list)

print_result(noun_dict, verb_dict)


html1.close()
html2.close()
html3.close()
html4.close()
html5.close()
html6.close()
html7.close()
html8.close()
html9.close()
html10.close()
