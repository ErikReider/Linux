#include <curl/curl.h>
#include <dirent.h>
#include <gtk/gtk.h>
#include <stdlib.h>
#include "functions.c"

GtkWidget *window;
GtkBuilder *mainBuilder;
GtkWidget *listBox;
GtkBuilder *dialogBuilder;

int *listOfGames;

gboolean closeDialog(GtkWidget *widget, GdkEvent *event, gpointer *userData) {
    gtk_widget_hide(getWidget(dialogBuilder, "dialog"));
    return TRUE;
}

void showDialog(GtkWidget *widget, GdkEvent *event, gpointer *userData) {
    g_return_if_fail(userData != NULL);
    const char *title = (char *)userData;
    GtkWidget *dialog = getWidget(dialogBuilder, "dialog");
    gtk_window_set_transient_for(GTK_WINDOW(dialog), GTK_WINDOW(window));
    g_signal_connect(dialog, "delete-event", G_CALLBACK(closeDialog), NULL);

    GtkWidget *label = getWidget(dialogBuilder, "dialogLabel");
    gtk_label_set_label(GTK_LABEL(label), title);

    GtkWidget *cancelButton = getWidget(dialogBuilder, "dialogCancelButton");
    g_signal_connect(cancelButton, "clicked", G_CALLBACK(closeDialog), NULL);

    gtk_widget_show_all(dialog);
    gtk_window_present(GTK_WINDOW(dialog));
    gtk_window_set_focus_visible(GTK_WINDOW(dialog), TRUE);
    int result = gtk_dialog_run(GTK_DIALOG(dialog));
    switch (result) {
        case GTK_RESPONSE_ACCEPT:
            // do_application_specific_something ();
            break;
        default:
            // do_nothing_since_dialog_was_cancelled ();
            break;
    }
}

int main(int argc, char **argv) {
    gtk_init(&argc, &argv);

    listOfGames = getGamesList("/home/erikreider/.steam/steam/userdata/143352235");

    mainBuilder = gtk_builder_new_from_file("glade/mainUI.glade");
    gtk_builder_connect_signals(mainBuilder, NULL);

    dialogBuilder = gtk_builder_new_from_file("glade/dialog.glade");
    gtk_builder_connect_signals(dialogBuilder, NULL);

    window = getWidget(mainBuilder, "window");
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    listBox = getWidget(mainBuilder, "listBox");

    getGamesList2("/home/erikreider/.steam/steam/config/config.vdf");
    for (int i = 0; i <= sizeof(listOfGames); i++) {
        const char *title = getGameNameFromID(intToGchar(listOfGames[i]));
        if (strcmp(title, "") == 0) continue;
        GtkWidget *item = gtk_menu_item_new_with_label(title);
        g_signal_connect(item, "button-press-event", G_CALLBACK(showDialog), (gpointer *)title);
        gtk_container_add(GTK_CONTAINER(listBox), item);
    }

    gtk_widget_show_all(window);
    gtk_main();
    return 0;
}