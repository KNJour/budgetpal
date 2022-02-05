from flask import Flask, render_template, request, redirect, session, flash
from datetime import datetime
from datetime import date
from mysqlconnection import connectToMySQL
from decimal import Decimal
from flask_bcrypt import Bcrypt
import re
app = Flask(__name__)
bcrypt = Bcrypt(app)
app.secret_key = "bananas are the best fruit"

EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$')
NAME_REGEX = re.compile(r'^[a-zA-Z]+$')
PMT_REGEX = re.compile(r"^\d*[.,]?\d*$")
#TAKE ME HOME, COUNTRY
@app.route('/')
def home():
    return render_template("index.html")

@app.route('/register')
def registration():
    return render_template("registration.html")

#REGISTRATION
@app.route('/submit', methods=['POST'])
def submit():
    session.clear()
    is_valid = True
    coolquery = "SELECT * FROM users"
    db_list = connectToMySQL("budgets").query_db(coolquery)
    for one in db_list: #   EMAIL VALIDATION
        if one['email'] == request.form['email']:
            is_valid = False
            flash("email is already taken", "email")
    if not EMAIL_REGEX.match(request.form['email']):
        is_valid = False
        flash("Invalid email address!")
    for one in db_list: #   USERNAME VALIDATION
        if one['user_name'] == request.form['username']:
            is_valid = False
            flash("that username is already taken", "username")
    if len(request.form['first_name']) < 2: # NAME VALIDATION
        is_valid = False
        flash("**Please enter a first name**", "firstname")
    if not NAME_REGEX.match(request.form['first_name']):
        is_valid = False
        flash("Name can only include letters", "firstname")
    if len(request.form['last_name']) < 2:
        is_valid = False
        flash("Please enter a last name")
    if not NAME_REGEX.match(request.form['last_name']):
        is_valid = False
        flash("name can only include letters")
    if len(request.form['password']) < 8:
        is_valid = False
        flash("Please enter a password with at least 8 characters") #PASSWORD VALIDATION
    if (request.form['password'] != request.form['confirm_password']):
        is_valid = False
        flash("Passwords DO NOT  Match")

    if not is_valid:
        return redirect ('/')
    
    else:
        flash("Registration Successful!", "register")
        hashedPass = bcrypt.generate_password_hash(request.form['password'])

        query = "INSERT INTO users (first_name, last_name, user_name, email, password, created_at, updated_at) VALUES (%(first_name)s,%(last_name)s, %(username)s, %(email)s, %(password)s,NOW(),NOW());"
        
        print(query)
        data = {
            'first_name' : request.form['first_name'],
            'last_name' : request.form['last_name'],
            'email' : request.form['email'].lower(),
            'password' : hashedPass,
            'username': request.form['username'].lower(),
            }
        users = connectToMySQL("budgets").query_db(query, data)
        print(users)
        
        return redirect ('/')
# THIS VALIDATES BUDGET
def validate_budget(budget):
    is_valid = True
    if len(budget['title']) <2:
        is_valid = False
        flash("Title must be at least 2 characters")
    if len(budget['description']) < 2:
        is_valid = False
        flash("Description must be at least 2 characters")
    return is_valid

#validates user after creation
def validate_user(user):
    is_valid = True
    coolquery = "SELECT * FROM users"
    db_list = connectToMySQL("budgets").query_db(coolquery)
    for one in db_list:
        if one['email'] == request.form['email']:
            if request.form['email'] == session['email']:
                break
            is_valid = False
            flash("email is already taken",)
    if len(request.form['first_name']) < 2:
        is_valid = False
        flash("**Please enter a first name**")
    if not NAME_REGEX.match(request.form['first_name']):
        is_valid = False
        flash("Name can only include letters")
    if len(request.form['last_name']) < 2:
        is_valid = False
        flash("Please enter a last name", "lastname")
    if not NAME_REGEX.match(request.form['last_name']):
        is_valid = False
        flash("name can only include letters")
    if not EMAIL_REGEX.match(request.form['email']):
        is_valid = False
        flash("Invalid email address!")

    return is_valid

def validate_pmt(pmt):
    is_valid = True
    if len(request.form['amount']) < 1:
        is_valid = False
        flash("is not a valid number")
    if not PMT_REGEX.match(request.form['amount']):
        is_valid = False
        flash("is not a valid number")
    return is_valid
    #LOGS OUT -clears session data

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

#LOGIN -Logs user in and stores user_id in session
@app.route('/login', methods=['POST'])
def login():
    emailquery = "SELECT * FROM users WHERE email = %(check)s"
    userquery = "SELECT * FROM users WHERE user_name = %(check)s"

    data = {
        'check' : request.form['username'].lower()
    }
    hashme = request.form['pass']
    print(request.form['username'].lower())
    print(hashme)
    email = connectToMySQL("budgets").query_db(emailquery, data)
    user = connectToMySQL("budgets").query_db(userquery, data)
    print(" USER CONTENTS")
    print(user)
    if (len(user) < 1) and (len(email) < 1):
        flash("no username or email found", "login")
        return redirect('/')
    print("HEEEERRREEE")
    if user:
        if bcrypt.check_password_hash(user[0]["password"], hashme):
            session['first_name'] = user[0]["first_name"]
            session['last_name'] = user[0]["last_name"]
            session['username'] = user[0]["user_name"]
            session['user_id'] = user[0]["id"]
            session['email'] = user[0]['email']
            return redirect('/dashboard')
        else:
            print ("THE ELSE")
            flash("password is incorrect", "login")
            return redirect('/')
    else:
        if bcrypt.check_password_hash(email[0]["password"], hashme):
            session['first_name'] = email[0]["first_name"]
            session['last_name'] = email[0]["last_name"]
            session['username'] = email[0]["user_name"]
            session['user_id'] = email[0]["id"]
            session['email'] = email[0]['email']
            return redirect('/dashboard')
        else:
            print ("THE ELSE")
            flash("password is incorrect", "login")
            return redirect('/')

# functions
def values_sucker(x):
    if isinstance(x, dict):
        for v in x.values():
            yield from values_sucker(v)
    elif isinstance(x, list):
        for v in x:
            yield from values_sucker(v)
    else:
        yield x 

def date_difference(date1, date2):
    return abs(date2-date1).days

@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        print("NOT IN SESSION")
        return redirect('/')
    queryFirst = "SELECT * FROM budgets WHERE budgets.user_id =%(user_id)s LIMIT 1;"
    all_budgets_query = "SELECT * FROM budgets WHERE user_id = %(user_id)s;"
    data = {
        "user_id": session['user_id'],
    }
    all_budgets = connectToMySQL('budgets').query_db(all_budgets_query,data)
    firstBudget = connectToMySQL('budgets').query_db(queryFirst,data)
    print("all_budgets HERE")
    print(all_budgets)
    if len(firstBudget) < 1:
        return render_template("dashboard.html")
    data2 = {
        "user_id": session['user_id'],
        "first" : firstBudget[0]['id']
    }
    # queries everything except the first budget 
    query = "SELECT * FROM budgets WHERE budgets.user_id = %(user_id)s AND budgets.id != %(first)s ;"
    budgets = connectToMySQL('budgets').query_db(query,data2)
    print(budgets)
    # first contains the first budget for the carousel to operate correctly. budgets has the remainder, and all budgets has them all for the list on the bottom
    return render_template("testdashboard.html", budgets = budgets, first = firstBudget, all_budgets = all_budgets)


#goes to edit budgets page
@app.route('/budgets')
def budgets():
    query = "SELECT * FROM budgets WHERE budgets.user_id = %(user_id)s;"
    data = {
        "user_id": session['user_id'],
    }
    budgets = connectToMySQL('budgets').query_db(query,data)

    return render_template("budgets_edit.html", budgets = budgets)
#CREATES THE BUDGET

@app.route('/create_budget', methods=['POST'])
def create_budget():
    query = "INSERT INTO budgets (budget_name, budget_description, balance, adj_balance, start_date,target_date, created_at, updated_at, user_id) VALUES (%(name)s, %(description)s, %(balance)s,%(balance)s,%(start)s,%(end)s, NOW(),NOW(),%(user_id)s);"

    data = {
        'name' : request.form['budget_name'],
        'description' : request.form['description'],
        'balance' : request.form['balance'],
        'start' : request.form['start'],
        'end' : request.form['end'],
        'user_id' : session['user_id'],
    }

    new_budget = connectToMySQL('budgets').query_db(query,data)
    print(new_budget)
    flash("budget successfully created!")
    return redirect("/budgets")

#SUBTRACTS THE AMOUNT ENTERED FROM THE ADJUSTED BALANCE
@app.route("/update_budget", methods=['POST'])
def update_budget():
    if 'user_id' not in session:
        return redirect('/dashboard')
    if not validate_pmt(request.form['amount']):
       return redirect ('/dashboard')
    query = "SELECT adj_balance FROM budgets WHERE budgets.id = %(budget_id)s;"

    # QUERYLOGS THE PAYMENT INTO SPENDING TABLE
    spendingQuery = "INSERT INTO spending (amount, timestamp, created_at, updated_at, budgets_id) VALUES (%(payment_amount)s, NOW(), NOW(), NOW(), %(budget_id)s);"

    data = {
        'budget_id' : request.form['budget_id'],
        'payment_amount' : request.form['amount']
    }
    current_balance = connectToMySQL("budgets").query_db(query,data)
    logSpending = connectToMySQL("budgets").query_db(spendingQuery, data)

    # newAmount = round(int(current_balance[0]['adj_balance']) - int(request.form['amount']), 2)
    newAmount = Decimal(current_balance[0]['adj_balance']) - Decimal(request.form['amount'])
    print(newAmount)

    adjust = "UPDATE budgets SET adj_balance = %(newAmount)s WHERE budgets.id = %(budget_id)s;"
    data2 = {
        'budget_id' : request.form['budget_id'],
        'newAmount' : newAmount
    }

    new = connectToMySQL("budgets").query_db(adjust,data2)

    return redirect("/dashboard")

@app.route('/show/<int:budget_id>')
def show(budget_id):
    if 'user_id' not in session:
        print("NOT IN SESSION")
        return redirect('/')

    data = {
        "budget_id": budget_id
    }

    query = "SELECT * FROM budgets WHERE budgets.id =%(budget_id)s;"
    spending_query = "SELECT * FROM spending WHERE budgets_id =%(budget_id)s;"

    budgets = connectToMySQL('budgets').query_db(query,data)
    spending = connectToMySQL('budgets').query_db(spending_query, data)
    print("SPENDING CHECK")
    print(spending)


    percentRemaining = round(int(budgets[0]['adj_balance']) / int(budgets[0]['balance']) * 100, 2)

    #dates
    date1 = budgets[0]['start_date']
    date2 = budgets[0]['target_date']
    date3 = date.today()
    duration = date_difference(date2, date1)
    currentDiff = date_difference(date3, date1)

    print(duration)
    print(currentDiff)
    dateRemaining = round(currentDiff / duration * 100, 2)
    dateRemaining = 100 - dateRemaining
    print(dateRemaining)

    if percentRemaining >= dateRemaining:
        status = "Good job! You are on track!"
    else:
        status = "You are not on track"
    return render_template("show.html", budgets = budgets, percentRemaining = percentRemaining, dateRemaining = dateRemaining, status = status, spending = spending)

#DELETE BUDGET
@app.route('/delete', methods=['POST'])
def delete():
    spending_query = "DELETE FROM spending WHERE budgets_id = %(id)s"
    query = "DELETE FROM budgets WHERE budgets.id = %(id)s;"
    data = {
        'id': request.form['budget_id']
    }
    spending_deleted = connectToMySQL('budgets').query_db(spending_query,data)
    deleted = connectToMySQL('budgets').query_db(query,data)
    return redirect('/budgets')

if __name__ == "__main__":
    app.run(debug=True)

