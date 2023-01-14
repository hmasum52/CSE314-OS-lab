false
echo "exit status of false is $?"
true
echo "exit status of true is $?"

echo ""

true && echo "done" 
echo "exit status of true && echo \"done\" is $?"
false && echo "done"
echo "exit status of false && echo \"done\" is $?"
false || echo "done"
echo "exit status of false || echo \"done\" is $?"
true || echo "done"
echo "exit status of true || echo \"done\" is $?"

echo ""


true; echo "done"
echo "exit status of true; echo \"done\" is $?"
false; echo "done"
echo "exit status of false; echo \"done\" is $?"