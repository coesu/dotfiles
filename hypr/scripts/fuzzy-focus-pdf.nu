#!/usr/bin/env nu

def focus_or_open_file [] {
    let target_dir = $"/home/lars/Zotero/storage/**/*.pdf"
    let target_dir2 = $"/home/lars/Zotero/storage"

    let open_files = hyprctl clients -j | from json | each {|client|
        if $client.title != "" and $client.class == "sioyek" {
            let file_name = ($client.title | split row "/" | last)
            {title: $file_name, address: $"address:($client.address)"}
        }
    } | where $it.title != "" | to json

    let directory_files = glob $target_dir | each {|file|
        let file_name = ($file | split row "/" | last)
        {title: $file_name, full_path: $file, address: ""}
    } | to json

    let combined_list = ($open_files | from json) ++ ($directory_files | from json | uniq-by title) | to json

    let choice = $combined_list | from json | select title | to text | cut -d ' ' -f 2- | anyrun --plugins libstdin.so
    if $choice != "" {
        let selected = ($combined_list | from json | where title == $choice | first)
        if $selected.address != "" {
            print $"Focusing on window: ($selected.title)"
            hyprctl dispatch focuswindow $selected.address
        } else {
            print $"Opening file: ($selected.full_path)"
            xdg-open $"($selected.full_path)"
        }
    }
}
focus_or_open_file
