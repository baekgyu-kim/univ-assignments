import re


def return_space_deleted_input_lines(input_lines):
    # 공백을 제거한 input_lines를 리턴합니다.
    pattern_tap_newline = r'\t|\n'
    regex_tap_newline = re.compile(pattern_tap_newline)

    pattern_spaces = r' {1,}'
    regex_spaces = re.compile(pattern_spaces)
    space_deleted_input_lines = []
    for i in range(len(input_lines)):
        input_line = input_lines[i]
        input_lines[i] = re.sub(regex_tap_newline, '', input_line)
        input_lines[i] = re.sub(regex_spaces, '', input_lines[i])
        if input_lines[i] == '':
            continue
        elif input_lines[i] != '':
            space_deleted_input_lines.append(input_lines[i])
    return space_deleted_input_lines


def return_input_lines_to_be_searched(input_lines):
    # 교수 소개 부분부터 footer가 나오기 전까지의 부분을 리턴합니다.
    prof_intro_index = input_lines.index("교수소개")
    footer_index = input_lines.index("<footer>")
    input_lines = input_lines[prof_intro_index:footer_index]
    return input_lines


def return_email_phone_homepage_list(input_lines):
    # email_list, phone_list, homepage_list를 순서대로 리스트에 담아서 리턴합니다.
    email_list = []
    phone_list = []
    homepage_list = []

    pattern_phone = r'02-\d{3,4}-\d{4}'
    regex_phone = re.compile(pattern_phone)

    pattern_between_ahref = r'<ahref[^>]*>(.*?)<\/a>'
    regex_between_ahref = re.compile(pattern_between_ahref)

    for i in range(len(input_lines)):
        line = input_lines[i]
        # 해당 라인이 <b>E-mail</b> 인 경우 그 다음 다음 라인에 email 정보가 있습니다.
        if line == "<b>E-mail</b>":
            email_line = input_lines[i+2]
            email = re.search(regex_between_ahref, email_line).group(1)
            email_list.append(email)
        # 해당 라인이 regex_phone 정규표현식과 매치된다면 해당 라인에 phone 정보가 있습니다.
        if re.search(regex_phone, line):
            phone_list.append(line)
        # 해당 라인이 <b>홈페이지:</b> 인 경우 그 바로 다음 라인에 homepage 정보가 있습니다.
        if line == "<b>홈페이지:</b>":
            homepage_line = input_lines[i+1]
            homepage = re.search(regex_between_ahref, homepage_line).group(1)
            homepage_list.append(homepage)
    return [email_list, phone_list, homepage_list]


def print_list(result, result_list):
    # 출력 형식에 맞추어 result_list를 출력합니다.
    result_str = ", ".join(result_list)
    print(result+": "+result_str)
    print("\n")


def print_result(input_lines):
    # email, phone, homepage 리스트 각각에 대해 print_list 함수를 호출해서 최종 결과를 출력합니다.
    result_list = return_email_phone_homepage_list(input_lines)
    email_list = result_list[0]
    phone_list = result_list[1]
    homepage_list = result_list[2]
    print_list("E-mail", email_list)
    print_list("Phone Number", phone_list)
    print_list("HomePage", homepage_list)


input_file = open('probelm2.html', 'r')
input_lines = input_file.readlines()

space_deleted_input_lines = return_space_deleted_input_lines(input_lines)
input_lines_to_be_searched = return_input_lines_to_be_searched(
    space_deleted_input_lines)

print_result(input_lines_to_be_searched)

input_file.close()
