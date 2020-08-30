# cmds.bash - load app-related functions and aliases
# only loaded if the related app is detected

# ========
# Examples
# ========

# # middleman
# alias bemar='bundle exec middleman article'
# alias bemid='bundle exec middleman'
# alias bemse='bundle exec middleman server'

# # rails
# alias beraic='bundle exec rails console'
# alias berais='bundle exec rails server'

# # rake
# alias berak='bundle exec rake'
# alias berakdm='bundle exec rake db:migrate'

# # rspec
# alias bersp='bundle exec rspec'

# # torquebox
# alias betde='bundle exec torquebox deploy'
# alias betru='bundle exec torquebox run'

# # bundler
# alias bexec='bundle exec'
# alias binst='bundle install'
# alias bupda='bundle update'
# alias busou='bundle update --source'

# # rb runs ruby code from the command line
# rb () {
#   [[ $1 == -l ]] && shift
#   case $? in
#     0 ) ruby -e "STDIN.each_line { |l| puts l.chomp.instance_eval(&eval('Proc.new { $@ }')) }";;
#     * ) ruby -e "puts STDIN.each_line.instance_eval(&eval('Proc.new { $@ }'))"                ;;
#   esac
# }
