#!/usr/bin/fish

function cp_m3u --description 'copy music from an M3U playlist'
    function is_valid_out_dir --no-scope-shadowing
        test -d $_flag_value
        and begin
            test -e $_flag_value
            or mkdir -v $_flag_value
        end
        or begin
            echo "`"$_flag_value"` is not a directory"
            false
        end
    end

    argparse \
        --name="cp_m3u" \
        --min-args=0 \
        --stop-nonopt \
        "h/help" \
        "o/out_dir=!is_valid_out_dir" \
        "m/flac_to_mp3" \
        -- $argv
    or return

    if     set -q _flag_h
        or set -q _flag_help

        echo -e "\
cp_m3u [OPTIONS] PLAYLIST...\n\
\n\
  -h --help        : Print this message.\n\
  -o --out_dir=DIR : Copy music to `DIR`. `CWD` if not specified.\n\
  -m --flac_to_mp3 : Convert FLAC files to MP3 files.\n\
\n\
The command line tool `ffmpeg` needs to be installed to convert\n\
FLAC files to MP3.\n\
\n\
  CWD      : Current Working Directory\n\
  DIR      : The directory to which the music will be copied.\n\
  PLAYLIST : Path to an M3U playlist. Extension must be `.m3u`.\n"
        return
    end

    set -l n (count $argv)
    if test $n -eq 0
        echo "No playlist given."
        return
    end

    set -l out_dir (
        if set -q _flag_o
            realpath $_flag_o
        else if set -q _flag_out_dir
            realpath $_flag_out_dir
        else
            pwd -P
        end
    )

    set -q _flag_m _flag_flac_to_mp3
    set -l flac_to_mp3 (math 2 - $status)

    for m3u in $argv
        if      test -e $m3u
            and test -f $m3u
            and string match -q -i "*.m3u" $m3u

            echo -e "\nPLAYLIST: "$m3u"\n"

            set -l mp3_path_file (string split -r -m 1 '/' (realpath $m3u))
            pushd $mp3_path_file[1]

            and set -l files (grep "^[^#]" $m3u)
            and for f in $files
                if      test -e $f
                    and test -f $f

                    echo $f

                    if      string match -q -i "*.flac" $f
                        and test $flac_to_mp3 -gt 0

                        set -l real_f         (realpath $f)
                        set -l flac_path_file (string split -r -m 1 '/' $real_f)
                        set -l out_mp3        (
                            string join "/" \
                                $out_dir \
                                (string replace -i -r "\\.flac\$" ".mp3" $flac_path_file[2])
                        )
                        echo "→ "$out_mp3

                        ffmpeg \
                            -y -v error -hide_banner -nostats -nostdin \
                            -i $real_f \
                            -c:v copy -b:a 320k \
                            $out_mp3
                        or begin
                            popd
                            return
                        end
                    else
                        cp -f -H -p -u $f $out_dir
                    end
                else
                    echo "SKIPPING: "$f
                end
            end

            popd
        else
            echo "`"$m3u"` is not an M3U playlist, ignoring…"
        end
    end
end
