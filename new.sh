export projectURL="https://github.com/ivanmoreau/sims4moddingboilerplate"

export user_name=$(id -u -n)
echo "henlo $user_name ~~"
printf "Quick. Enter project name: "
read project_name
echo "Cool. So «${project_name}» then. Okay..."
echo "Your package is going to be called ${user_name}_${project_name}.ts4script"
printf "Press enter to continue or Ctrl+C to cancel"
read
echo "Good. Let's go..."

# Check if git is installed
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi
# git clone to ${project_name}_sims4mod
git clone $projectURL $project_name_sims4mod

export infered_py_verr=$(python3 -V | grep "Python 3.7" | wc -l)
if [ $infered_py_verr -eq 0 ]; then
  echo "Error: Python 3.7 is not installed." >&2
  echo "You can install it with Homebrew: brew install python@3.7"
  echo "Or maybe you have Python 3.7 installed but not in the PATH."
  printf "Is Python 3.7 installed? (y/n): "
  read py_i_i
  export py_is_installed2=$(echo $py_i_i | grep -i "y" | wc -l)
  if [ $py_is_installed2 -eq 0 ]; then
    echo "Okay. You can install it and then run this script again."
    exit 1
  fi
  echo "Okay. Then I need the location of the Python 3.7 executable."
  printf "Path="
  read new_py_path
  export PyPath=$new_py_path
else
  echo "Python 3.7 is installed. Good."
  export PyPath=$(which python3)
fi

# Set common things
cat ${project_name_sims4mod}/Makefile | sed -e "s/^\(PY = \"\).*/\1${PyPath}\"/" > ${project_name_sims4mod}/Makefile.tmp
mv ${project_name_sims4mod}/Makefile.tmp ${project_name_sims4mod}/Makefile
# Replace ANONVAR with user name
cat ${project_name_sims4mod}/Makefile | sed -e "s/ANONVAR/${user_name}/" > ${project_name_sims4mod}/Makefile.tmp
mv ${project_name_sims4mod}/Makefile.tmp ${project_name_sims4mod}/Makefile
# Replace some_good_mod with project name
cat ${project_name_sims4mod}/Makefile | sed -e "s/some_good_mod/${project_name}/" > ${project_name_sims4mod}/Makefile.tmp
mv ${project_name_sims4mod}/Makefile.tmp ${project_name_sims4mod}/Makefile

echo "Which language do you want to use?"
echo "1. Python"
echo "2. Hy (Lisp)"
printf "Choice: "
read lang_choice

# Check for Python choice
if [ $lang_choice -eq 1 ]; then
  echo "Python is not yet supported. But I'm not sorry."
  echo "This is a good chance to learn Lisp, eh? uwu"
  echo "Or are you just a Python fan? :3"
  echo "Hehe."
  echo "Just so you know, you don't need to install anything."
  echo "Just run this script again and it will do the rest."
  echo "I'm not going to bother you with installing anything."
  echo "This script will do the rest. That's the power of the venv."
  echo "Try it out! :3"
  echo "Btw, I'm going to exit with a 1 error code. You can ignore it."
  echo "Have fun! :3"
  exit 1
fi

# Check for Hy choice
if [ $lang_choice -eq 2 ]; then
  echo "Applying Hy changes to Makefile..."
  # Right now, Hy is the only supported language.
  # So we are done here.
  # But we will add more languages later.
  echo "Done."
fi

rm ${project_name_sims4mod}/new.sh
rm ${project_name_sims4mod}/README.md
echo "Do you want to keep the LICENSE file? (y/n)"
read keep_lic
export keep_lic2=$(echo $keep_lic | grep -i "y" | wc -l)
if [ $keep_lic2 -eq 0 ]; then
  echo "Okay. I will remove the LICENSE file."
  ${project_name_sims4mod}/rm LICENSE
fi
rm -rf ${project_name_sims4mod}/.git
cd ${project_name_sims4mod}/ && git init . && git add . && git commit -m "Initial commit 🥳."

echo "All done! Now you can run make init to set the environment."
echo "--- HELP INIT ---"
echo "make init: Initializes the environment."
echo "make build: Builds the package."
echo "make clean: Cleans the environment."
echo "make install: Installs the package. (Change the mod path int the Makefile if you need to)"
echo "make package: Builds the .ts4script package."
echo "make main: Generates the main.py file. Hello world."
echo "make: Build and package the mod."
echo "--- HELP END ---"

echo "That's all."
