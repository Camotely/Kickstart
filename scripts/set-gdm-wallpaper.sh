#! /bin/sh

image="$(realpath "../backgrounds/1.jpg")"

if [ ! -f "$image" ]; then
  echo "File not found: \"$image\" "
  exit 1
fi

# Dependencies
dnf update
dnf install glib2-devel -y

# Restore gresource from backup if current gresource is modified
if grep -q "wallpaper-gdm.png" /usr/share/gnome-shell/gnome-shell-theme.gresource; then
  cp -f /usr/share/gnome-shell/gnome-shell-theme.gresource.backup /usr/share/gnome-shell/gnome-shell-theme.gresource
fi

workdir=$(mktemp -d)
cd "$workdir"

# Creating gnome-shell-theme.gresource.xml with theme file list and add header
echo '<?xml version="1.0" encoding="UTF-8"?>' >"$workdir/gnome-shell-theme.gresource.xml"
echo '<gresources><gresource>' >>"$workdir/gnome-shell-theme.gresource.xml"

for res_file in $(gresource list /usr/share/gnome-shell/gnome-shell-theme.gresource); do
  # create dir for theme file inside temp dir
  mkdir -p "$(dirname "$workdir$res_file")"

  if [ "$res_file" != "/org/gnome/shell/theme/wallpaper-gdm.png" ]; then
    # extract file ($res_file) from current theme and write it to temp dir ($workdir)
    gresource extract /usr/share/gnome-shell/gnome-shell-theme.gresource "$res_file" >"$workdir$res_file"

    # add extracted file name to gnome-shell-theme.gresource.xml
    echo "<file>${res_file#\/}</file>" >>"$workdir/gnome-shell-theme.gresource.xml"
  fi
done

# add our image ($image) to theme path and to xml file
echo "<file>org/gnome/shell/theme/wallpaper-gdm.png</file>" >>"$workdir/gnome-shell-theme.gresource.xml"
cp -f "$image" "$workdir/org/gnome/shell/theme/wallpaper-gdm.png"

# add footer to xml file
echo '</gresource></gresources>' >>"$workdir/gnome-shell-theme.gresource.xml"


# find #lockDialogGroup block inside gnome-shell.css and replace with new_theme_params with our image
# and add image_parameters
new_theme_params="background: #2e3436 url(resource:\/\/\/org\/gnome\/shell\/theme\/wallpaper-gdm.png);$image_parameters"
sed -i -z -E "s/#lockDialogGroup \{[^}]+/#lockDialogGroup \{$new_theme_params/g" "$workdir/org/gnome/shell/theme/gnome-shell.css"

# create gresource file with file list inside gnome-shell-theme.gresource.xml
glib-compile-resources "$workdir/gnome-shell-theme.gresource.xml"

# Do backup only for original gresource file, not modified by this script.
# If wallpaper-gdm.png text inside gresource file, then this is modified file.
if ! grep -q "wallpaper-gdm.png" /usr/share/gnome-shell/gnome-shell-theme.gresource; then
  cp -f /usr/share/gnome-shell/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource.backup
  echo "Backup"
fi

cp -f "$workdir/gnome-shell-theme.gresource" /usr/share/gnome-shell/

# Strange but safe from bug
rm -rf "$workdir/org"
rm -f "$workdir/gnome-shell-theme.gresource.xml"
rm -f "$workdir/gnome-shell-theme.gresource"
rm -r "$workdir"

# Remove dependencies
dnf autoremove glib2-devel -y
