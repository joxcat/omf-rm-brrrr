function denied
    echo "Denied brrr..."
end

function rm -d "Safe wrapper to delete universe"
    set -l oldargs $argv
    set -l options (fish_opt -s h -l help)
    set options $options (fish_opt -s d)
    set options $options (fish_opt -s f)
    set options $options (fish_opt -s i)
    set options $options (fish_opt -s P)
    set options $options (fish_opt -s r)
    set options $options (fish_opt -s v)
    argparse $options -- $argv

    set -l root (ls -l1 / | sort -f | awk '{printf "/%s\n", $0}')

    if test "$argv" = "/"; or test "$argv" = "$HOME"; or test "$argv" = "$root"
        denied
    else
        if test "$_flag_r"; and test "$_flag_f"
            set -l res (find "$argv" 2>/dev/null)
            if test $status = 0
                echo $res | grep -Ev '^\.$'
                read --prompt-str='Are you sure you want to delete these? (y/N) ' $some >/dev/null
                switch $some
                case y Y yes Yes
                    /bin/rm $oldargs
                case '*'
                    echo "Pfuuu saved some cats here cap'tain"
                end
            else
                echo "rm: '$argv': No such file or directory"
            end
        else
            /bin/rm $oldargs
        end
    end
end
