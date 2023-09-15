import re


def return_something_between_AB_list(input_word):
    # something_between_ABs들을 찾아서 리스트로 리턴합니다.
    pattern_AB_something_AB = r'[AB].*[AB]'
    regex_AB_something_AB = re.compile(pattern_AB_something_AB)
    AB_something_AB_list = regex_AB_something_AB.findall(input_word)

    something_between_AB_list = []
    for i in range(len(AB_something_AB_list)):
        AB_something_AB = AB_something_AB_list[i]
        if len(AB_something_AB) == 2:
            continue
        something_between_AB_list.append(AB_something_AB[1:-1])
    something_between_AB_list = list(set(something_between_AB_list))
    return something_between_AB_list


def return_deleted_word(input_word):
    # something_between_AB를 ABs_contained_in_something으로 바꿉니다.
    something_between_AB_list = return_something_between_AB_list(input_word)
    for i in range(len(something_between_AB_list)):
        something_between_AB = something_between_AB_list[i]
        ABs_contained_in_something = ""
        for j in something_between_AB:
            if j == "A" or j == "B":
                ABs_contained_in_something += j
        input_word = re.sub(something_between_AB,
                            ABs_contained_in_something, input_word)
    return input_word


def return_deleted_list(input_word_list):
    # 반복문을 돌면서 각각의 input_word에 대해 return_deleted_word를 호출하여 something_between_AB 꼴이 ABs_contained_in_something으로 바뀐 word들의 리스트를 리턴합니다.
    for i in range(len(input_word_list)):
        input_word = input_word_list[i]
        deleted_input_word = return_deleted_word(input_word)
        input_word_list[i] = deleted_input_word
    return input_word_list


def decrypt(deleted_input_word):
    # A또는 B가 연속해서 5번 나오는 패턴에 대해 decrypt 합니다.
    pattern_five_ABs = r'[A|B]{5}'
    regex_five_ABs = re.compile(pattern_five_ABs)
    five_ABs_list = regex_five_ABs.findall(deleted_input_word)
    for i in range(len(five_ABs_list)):
        five_ABs = five_ABs_list[i]
        decrypted_char = ciper_table[five_ABs]
        deleted_input_word = re.sub(
            five_ABs, decrypted_char, deleted_input_word)
    return deleted_input_word


def return_decrypted_list(deleted_input_word_list):
    # 반복문을 돌면서 각각의 word에 대해 decrypt 함수를 호출하여 decrypt 된 word들의 리스트를 리턴합니다.
    for i in range(len(deleted_input_word_list)):
        deleted_input_word = deleted_input_word_list[i]
        decrypted_word = decrypt(deleted_input_word)
        deleted_input_word_list[i] = decrypted_word
    return deleted_input_word_list


def return_result_URL(input_text_list):
    # 최종 result를 리턴합니다.
    result_URL = ' '.join(input_text_list)
    result_URL = result_URL.replace(" ", "")
    result_URL = result_URL.replace("\n", "")
    result_URL = result_URL.lower()
    return result_URL


ciper_table = {
    "AAAAA": "A",
    "AAAAB": "B",
    "AAABA": "C",
    "AAABB": "D",
    "AABAA": "E",
    "AABAB": "F",
    "AABBA": "G",
    "AABBB": "H",
    "ABAAA": "I",
    "ABAAB": "J",
    "ABABA": "K",
    "ABABB": "L",
    "ABBAA": "M",
    "ABBAB": "N",
    "ABBBA": "O",
    "ABBBB": "P",
    "BAAAA": "Q",
    "BAAAB": "R",
    "BAABA": "S",
    "BAABB": "T",
    "BABAA": "U",
    "BABAB": "V",
    "BABBA": "W",
    "BABBB": "Y",
    "BBAAB": "Z"
}


input_file = open('input.txt', 'r')
input_text = input_file.read()
input_word_list = input_text.split(" ")

deleted_input_word_list = return_deleted_list(input_word_list)
decrypted_input_word_list = return_decrypted_list(deleted_input_word_list)

result_URL = return_result_URL(input_word_list)
print(result_URL)

input_file.close()
