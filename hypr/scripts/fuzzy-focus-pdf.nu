#!/usr/bin/env nu

def get_compositor [] {
    if ($env.HYPRLAND_INSTANCE_SIGNATURE? | is-empty) == false {
        return "hyprland"
    } else if ($env.SWAYSOCK? | is-empty) == false {
        return "sway"
    } else {
        return "unknown"
    }
}

def get_open_files_hypr [] {
    hyprctl clients -j | from json | each {|client|
        if $client.title != "" and $client.class == "org.pwmt.zathura" {
            let file_name = ($client.title | split row "/" | last)
            {title: $file_name, address: $"address:($client.address)"}
        }
    } | where $it.title != ""
}

def get_open_files_sway [] {
    def walk_tree [node] {
        mut matches = []

        if ($node.nodes | is-empty) == false {
            for n in $node.nodes {
                $matches = ($matches ++ (walk_tree $n))
            }
        }

        if ($node.app_id? == "org.pwmt.zathura" or ($node.name? != null and $node.name? =~ '\.pdf$')) {
            let file_name = ($node.name | split row "/" | last)
            $matches = ($matches ++ [{ title: $file_name, address: $node.id }])
        }

        return $matches
    }

    let tree = swaymsg -t get_tree | from json
    walk_tree $tree
}

def focus_window [compositor: string, address] {
    if $compositor == "hyprland" {
        hyprctl dispatch focuswindow $address
    } else if $compositor == "sway" {

        print $"Raw address: ($address)"
        swaymsg ...[ $"[con_id=($address)]", "focus" ]
    }
}

def focus_or_open_file [] {
    let compositor = get_compositor

    if $compositor == "unknown" {
        print "Unsupported compositor"
        exit 1
    }

    let target_dir = "/home/lars/Zotero/storage/**/*.pdf"

    let open_files = if $compositor == "hyprland" {
        get_open_files_hypr
    } else {
        get_open_files_sway
    }

    let directory_files = glob $target_dir | each {|file|
        let file_name = ($file | split row "/" | last)
        {title: $file_name, full_path: $file, address: ""}
    }

    let combined_list = ($open_files ++ ($directory_files | uniq-by title))

    let choice = $combined_list | select title | get title | to text | wmenu -l 10 -i

    if $choice != "" {
        let selected = ($combined_list | where title == $choice | first)
        if $selected.address != "" {
            print $"Focusing on window: ($selected.title)"
            focus_window $compositor $selected.address
        } else {
            print $"Opening file: ($selected.full_path)"
            xdg-open $"($selected.full_path)"
        }
    }
}

focus_or_open_file
