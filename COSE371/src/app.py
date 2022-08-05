import psycopg2
from flask import Flask, render_template, request

app = Flask(__name__)
connect = psycopg2.connect("dbname=term user=postgres password=5555")
cur = connect.cursor()


def category_buyer_seller_itemlist():
    cur.execute(
        "select type from category, trade where category.code = trade.code group by type order by count(type) desc")
    popular_category_list = cur.fetchall()
    popular_category = popular_category_list[0][0]

    cur.execute(
        "select buyer from trade group by buyer order by sum(trade_price) desc")
    best_buyer_list = cur.fetchall()
    best_buyer = best_buyer_list[0][0]

    cur.execute(
        "select seller from trade group by seller order by sum(trade_price) desc")
    best_seller_list = cur.fetchall()
    best_seller = best_seller_list[0][0]

    cur.execute("select * from items")
    items_list = cur.fetchall()
    return (popular_category, best_buyer, best_seller, items_list)


def quotation(string):
    return "'{}'".format(string)


def balance_rating_admin(ID):
    if ID == "admin":
        admin = True
    else:
        admin = False
    cur.execute("select * from account where id = {}".format(quotation(ID)))
    temp_list = cur.fetchall()
    balance = temp_list[0][1]
    rating = temp_list[0][2]
    result_list = []
    result_list.append(balance)
    result_list.append(rating)
    result_list.append(admin)
    return result_list


def render_template_login_success(ID):
    user_info = balance_rating_admin(ID)
    balance = user_info[0]
    rating = user_info[1]
    admin = user_info[2]
    view_info = category_buyer_seller_itemlist()
    popular_category = view_info[0]
    best_buyer = view_info[1]
    best_seller = view_info[2]
    items_list = view_info[3]
    return render_template("login_success.html", admin=admin, popular_category=popular_category, best_buyer=best_buyer, best_seller=best_seller, ID=ID, balance=balance, rating=rating, items_list=items_list)


def rating_discount(balance):
    cur.execute(
        "select * from rating_info")
    rating_info = cur.fetchall()
    for i in range(len(rating_info)):
        ith_rating = rating_info[i][0]
        ith_balance = rating_info[i][1]
        ith_discount = rating_info[i][2]
        if balance >= ith_balance:
            return (ith_rating, ith_discount)


def match_balance_rating(ID, balance):
    original_rating = balance_rating_admin(ID)[1]
    real_rating = rating_discount(balance)[0]
    if real_rating != original_rating:
        cur.execute(
            "update account set rating = {} where id = {}".format(quotation(real_rating), quotation(ID)))
        connect.commit()


def discount_price(original_price, rating):
    cur.execute(
        "select discount from rating_info where rating = {}".format(quotation(rating)))
    discount = float(cur.fetchall()[0][0])
    temp = 1 - (discount/100)
    discount_price = float(original_price) * temp
    return discount_price


@app.route('/')
def login():
    return render_template("login.html")


@app.route('/return', methods=['post'])
def re_turn():
    return render_template("login.html")


@app.route('/login_action', methods=['post'])
def login_action():
    ID = request.form["ID"]
    pw = request.form["password"]
    send = request.form["send"]

    cur.execute(
        "select ID, password as pw from users")
    ID_pw = cur.fetchall()

    if send == "login":
        for i in range(len(ID_pw)):
            if ID == ID_pw[i][0] and pw == ID_pw[i][1]:
                user_info = balance_rating_admin(ID)
                balance = user_info[0]
                rating = user_info[1]
                match_balance_rating(ID, int(balance))
                return render_template_login_success(ID)
        return render_template("login_fail.html")

    elif send == "sign up":
        collision = False
        for i in range(len(ID_pw)):
            if ID == ID_pw[i][0]:
                collision = True
                break
        if collision == True:
            return render_template("ID_collision.html")
        else:
            cur.execute("insert into users values('{}', '{}');".format(ID, pw))
            cur.execute(
                "insert into account values('{}','{}','{}');".format(ID, 0, "beginner"))
            connect.commit()
            return render_template_login_success(ID)


@app.route('/admin_function', methods=['post'])
def admin_function():
    send = request.form["send"]
    if send == 'users info':
        cur.execute("select * from users")
        users = cur.fetchall()
        return render_template("print_users.html", users=users)
    else:
        cur.execute("select * from trade")
        trades = cur.fetchall()
        return render_template("print_trades.html", trades=trades)


@app.route('/cash', methods=['post'])
def cash():
    in_out = request.form["in_out"]
    ID = request.form["ID"]
    user_info = balance_rating_admin(ID)
    balance = user_info[0]
    rating = user_info[1]
    return render_template("cash.html", in_out=in_out, ID=ID, balance=balance, rating=rating)


@app.route('/cash_action', methods=['post'])
def cash_action():
    in_out = request.form["in_out"]
    ID = request.form["ID"]
    cash_amount_str = request.form["cash_amount"]
    cash_amount = int(cash_amount_str)
    user_info = balance_rating_admin(ID)
    balance_str = user_info[0]
    balance = int(balance_str)
    if in_out == "충전":
        cur.execute(
            "update account set balance = balance + {} where id = {}".format(cash_amount, quotation(ID)))
        connect.commit()
        match_balance_rating(ID, balance+cash_amount)
    else:
        if cash_amount > balance:
            return render_template("cash_out_fail.html")
        cur.execute(
            "update account set balance = balance - {} where id = {}".format(cash_amount, quotation(ID)))
        connect.commit()
        match_balance_rating(ID, balance-cash_amount)
    return render_template_login_success(ID)


@app.route('/add', methods=['post'])
def add():
    ID = request.form["ID"]
    category_list = [['00', 'books'], [
        '01', 'electronics'], ['02', 'clothing']]

    return render_template("add.html", category_list=category_list, ID=ID)


@app.route('/add_action', methods=['post'])
def add_action():
    code = request.form["code"]
    name = request.form["name"]
    price = request.form["price"]
    stock = request.form["stock"]
    ID = request.form["ID"]

    if code == '00' or code == '01' or code == '02':
        cur.execute("select * from items")
        code_name_price_stock_seller = cur.fetchall()
        same_item = False
        for item in code_name_price_stock_seller:
            ith_code = item[0]
            ith_name = item[1]
            ith_price = item[2]
            ith_stock = item[3]
            ith_seller = item[4]
            if code == ith_code and name == ith_name and price == ith_price and ID == ith_seller:
                new_stock = stock + ith_stock
                same_item = True
                break
        if same_item == True:
            cur.execute(
                "update items set stock = {};".format(new_stock))
            connect.commit()
        else:
            cur.execute(
                "insert into items values('{}', '{}', '{}', '{}', '{}');".format(code, name, price, stock, ID))
            connect.commit()
        return render_template_login_success(ID)
    else:
        return render_template("item_code_fail.html")


@app.route('/buy', methods=['post'])
def buy():
    ID = request.form["ID"]
    code = request.form["code"]
    name = request.form["name"]
    price = request.form["price"]
    stock = request.form["stock"]
    seller = request.form["seller"]
    user_info = balance_rating_admin(ID)
    balance = user_info[0]
    rating = user_info[1]
    return render_template("buy.html", ID=ID, balance=balance, rating=rating, code=code, name=name, price=price, stock=stock, seller=seller)


@app.route('/buy_action', methods=['post'])
def buy_action():
    ID = request.form["ID"]
    buyer = ID
    buyer_info = balance_rating_admin(buyer)
    buyer_balance = buyer_info[0]
    buyer_rating = buyer_info[1]

    code = request.form["code"]
    name = request.form["name"]
    seller_price = float(request.form["price"])
    buyer_price = discount_price(seller_price, buyer_rating)
    stock = int(request.form["stock"])
    seller = request.form["seller"]
    seller_balance = balance_rating_admin(seller)[0]
    amount = int(request.form["amount"])

    buyer_minus = buyer_price * amount
    seller_plus = seller_price * amount
    buyer_new_balance = buyer_balance - buyer_minus
    seller_new_balance = seller_balance + seller_plus

    if amount > stock:
        return render_template("buy_fail_stock.html")
    if buyer_minus > buyer_balance:
        return render_template("buy_fail_balance.html")

    new_stock = stock - amount

    # items update
    if new_stock == 0:
        cur.execute("delete from items where code = {} and name = {} and price = {} and seller = {}".format(
            quotation(code), quotation(name), seller_price, quotation(seller)))
        connect.commit()
    else:
        cur.execute("update items set stock = {} where code = {} and name = {} and price = {} and seller = {}".format(
            new_stock, quotation(code), quotation(name), seller_price, quotation(seller)))

    # account update
    cur.execute("update account set balance = {} where id = {}".format(
        buyer_new_balance, quotation(buyer)))
    cur.execute("update account set balance = {} where id = {}".format(
        seller_new_balance, quotation(seller)))
    connect.commit()
    match_balance_rating(buyer, buyer_balance)
    match_balance_rating(seller, seller_balance)

    # trade update
    cur.execute("insert into trade values({}, {}, {}, {})".format(
        quotation(buyer), quotation(seller), quotation(code), seller_price))
    connect.commit()

    return render_template_login_success(ID)


@app.route('/check_category', methods=['post'])
def check_category():
    ID = request.form["ID"]
    category_list = [['00', 'books'], [
        '01', 'electronics'], ['02', 'clothing']]
    code = request.form["code"]
    name = request.form["name"]
    price = request.form["price"]
    stock = request.form["stock"]
    seller = request.form["seller"]
    return render_template("check_category.html", ID=ID, category_list=category_list, code=code, name=name, price=price, stock=stock, seller=seller)


@app.route('/check_category_action', methods=['post'])
def check_category_action():
    ID = request.form["ID"]
    category = request.form["category"]
    code = request.form["code"]
    name = request.form["name"]
    price = request.form["price"]
    stock = request.form["stock"]
    seller = request.form["seller"]

    if category == '00' or category == '01' or category == '02':
        cur.execute(
            "update items set code = {} where code = {} and name = {} and price = {} and stock = {} and seller = {}".format(quotation(category), quotation(code), quotation(name), price, stock, quotation(seller)))
        connect.commit()
        return render_template_login_success(ID)
    else:
        return render_template("item_code_fail.html")


if __name__ == '__main__':
    app.run()
