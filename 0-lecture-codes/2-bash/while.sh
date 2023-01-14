password="admin" #default password

echo -n "enter password: "
read password

while [ $password != "admin" ]; do
    echo "wrong password, try again"
    echo -n "enter password: "
    read password
done
echo "Login successful"