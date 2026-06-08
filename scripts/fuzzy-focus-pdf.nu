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

def pdf_title [value: string] {
    $value | split row "/" | last | str replace -r ' - zathura$' ''
}

def get_open_files_hypr [] {
    hyprctl clients -j | from json | each {|client|
        let title = ($client.title? | default "")
        let class = ($client.class? | default "")

        if $title != "" and (($class | str downcase) =~ "zathura" or ($title | str downcase) =~ '\.pdf') {
            let file_name = pdf_title $title
            {label: $"[open] ($file_name)", title: $file_name, full_path: "", address: $client.address, workspace: $client.workspace.name}
        }
    } | where {|entry| $entry != null and $entry.title != ""}
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
            let file_name = pdf_title $node.name
            $matches = ($matches ++ [{label: $"[open] ($file_name)", title: $file_name, full_path: "", address: $node.id, workspace: "" }])
        }

        return $matches
    }

    let tree = swaymsg -t get_tree | from json
    walk_tree $tree
}

def focus_window [compositor: string, selected: record] {
    if $compositor == "hyprland" {
        let selector = $"address:($selected.address)"
        let workspace = ($selected.workspace? | default "")

        if $workspace != "" {
            let focus_workspace = ("hl.dsp.focus({ workspace = \"" + $workspace + "\" })")
            hyprctl dispatch $focus_workspace | ignore
        }

        let focus_window = ("hl.dsp.focus({ window = \"" + $selector + "\" })")
        hyprctl dispatch $focus_window | ignore
    } else if $compositor == "sway" {

        print $"Raw address: ($selected.address)"
        swaymsg ...[ $"[con_id=($selected.address)]", "focus" ]
    }
}

def focus_or_open_file [] {
    let compositor = get_compositor

    if $compositor == "unknown" {
        print "Unsupported compositor"
        exit 1
    }

    let target_dir = ($env.DOTFILES_PDF_GLOB? | default $"($env.HOME)/Zotero/storage/**/*.pdf")

    let open_files = if $compositor == "hyprland" {
        get_open_files_hypr
    } else {
        get_open_files_sway
    }

    let directory_files = glob $target_dir | each {|file|
        let file_name = ($file | split row "/" | last)
        {label: $file_name, title: $file_name, full_path: $file, address: "", workspace: ""}
    }

    let combined_list = ($open_files ++ $directory_files) | uniq-by title

    let choice = $combined_list | get label | to text | rofi-dmenu --width 900 --placeholder "Search PDF files"

    if $choice != "" {
        let selected = ($combined_list | where label == $choice | first)
        if $selected.address != "" {
            print $"Focusing on window: ($selected.title)"
            focus_window $compositor $selected
        } else {
            print $"Opening file: ($selected.full_path)"
            xdg-open $"($selected.full_path)"
        }
    }
}

focus_or_open_file
