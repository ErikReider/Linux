#include <glibmm-2.4/glibmm.h>
#include <gtkmm-3.0/gtkmm.h>
#include <gtkmm.h>
#include <iostream>
#include "functions.cpp"

Glib::RefPtr<Gtk::Application> app;
Gtk::Window *window;
Glib::RefPtr<Gtk::Builder> mainBuilder;
Glib::RefPtr<Gtk::Builder> dialogBuilder;
Gtk::ListBox *listBox;

void on_button_clicked() {
    std::cout << "Hello World" << std::endl;
}

void buildList() {
    mainBuilder->get_widget("listBox", listBox);
    for (int i = 0; i < 50; i++) {
        const char *title = "getGameNameFromID(intToGchar(listOfGames[i]))";
        if (strcmp(title, "") == 0) continue;
        Gtk::MenuItem item = Gtk::MenuItem();
        item.add_label("asdsads", false, Gtk::ALIGN_CENTER);
        listBox->add(item);
        // g_signal_connect(item, "button-press-event", G_CALLBACK(showDialog), (gpointer *)title);
    }
    listBox->show_all();
}

int main(int argc, char **argv) {
    app = Gtk::Application::create(argc, argv, "org.gtkmm.example");

    mainBuilder = Gtk::Builder::create_from_file("glade/mainUI.glade");
    dialogBuilder = Gtk::Builder::create_from_file("glade/dialog.glade");

    mainBuilder->get_widget("window", window);
    if (window) {
        buildList();
        window->show_all();
        app->run(*window);
    }

    delete window;

    return 0;
}