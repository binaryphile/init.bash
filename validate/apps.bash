# apps.bash - run validations in the apps dir

for file in $(ListDir $Here/apps); do
  source $Here/apps/$file
done
