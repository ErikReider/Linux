#include <curl/curl.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <json-glib/json-glib.h>

char *intToGchar(int i) {
    return g_strdup_printf("%i", i);
}

int charInList(int value, int *list) {
    for (int i = 0; i < sizeof(list) / sizeof(int); i++) {
        if (value == list[i]) {
            return 1;
        }
    }
    return 0;
}

char *addChar(char *first, char *second) {
    char *str = (char *)malloc(sizeof(char) + strlen(first) + strlen(second));
    strcpy(str, first);
    strcat(str, second);
    return str;
}

char *surroundChar(char *first, char *second, char *third) {
    char *str = (char *)malloc(sizeof(char) * (strlen(first) + strlen(second) + strlen(third)));
    strcpy(str, first);
    strcat(str, second);
    strcat(str, third);
    return str;
}

GtkWidget *getWidget(GtkBuilder *builder, gchar *id) {
    return GTK_WIDGET(gtk_builder_get_object(builder, id));
}

int *getGamesList(char *dir) {
    DIR *folder = opendir(dir);
    struct dirent *entry;
    if (folder == NULL) {
        puts("Unable to read directory");
        exit(1);
    }
    int size = 0;
    while (entry = readdir(folder)) {
        // Check if all dirs only contain numbers
        if (strspn(entry->d_name, "0123456789") > 0) {
            size++;
        }
    }
    int *listOfGames = (int *)malloc(sizeof(int) * size);
    if (listOfGames == NULL) {
        g_print("malloc of size %d failed!\n", size);
        exit(1);
    }

    folder = opendir(dir);
    int index = 0;
    while (entry = readdir(folder)) {
        // Check if all dirs only contain numbers
        if (strspn(entry->d_name, "0123456789") > 0) {
            g_print(entry->d_name);
            g_print("\n");
            g_print("\n");
            listOfGames[index] = atoi(entry->d_name);
            index++;
        }
    }
    if (index != size) {
        g_print("INDEX != SIZE!!!");
        exit(1);
    }
    closedir(folder);
    return listOfGames;
}

void getValueFromJSON(char *dir, char path[]) {
    FILE *fp;
    if ((fp = fopen(dir, "r")) == NULL) {
        printf("Error! opening file");
        exit(1);
    }
    // Gets the size of the file
    long size;
    fseek(fp, 0, SEEK_END);
    size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    char *c = (char *)malloc(sizeof(char) * size);

    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    int openBracketPos = 0;
    int keyPos = 0;

    while ((read = getline(&line, &len, fp)) != -1) {
        char *list = strtok(path, "/");
        int index = 0;
        while (list != NULL) {
            // printf("%s", surroundChar("\"", line, "\""));
            printf("%s\n", list);
            if (strstr(line, list) != NULL) {
                // printf("%s\n", list);
            }
            list = strtok(NULL, "/");
            index++;
        }
        if (strstr(line, "{")) {
            openBracketPos++;
            printf("%i %s\n", openBracketPos, line);
        }
        if (strstr(line, "}")) {
            printf("%i %s\n", openBracketPos, line);
            openBracketPos--;
        }
    }
}

int *getGamesList2(char *dir) {
    // fclose(fp);
    getValueFromJSON(
        dir, "InstallConfigStore/Software/Valve/Steam/ShaderCacheManager/CommittedDepotManifests");
    // GError *error = NULL;
    // const char *path = "$.UserLocalConfigStore.Software.Valve.Steam.Apps";
    // JsonArray *results = json_node_get_array(
    //     json_path_query(path, json_parser_load_from_file(json_parser_new(), &dir, &error),
    //     &error));
    // if (error != NULL) {
    //     fprintf(stderr, "%s", error->message);
    //     exit(1);
    // }
    // const gchar *result;
    // if (json_array_get_length(results) == 1) {
    //     result = json_array_get_string_element(results, 0);
    // } else {
    //     g_print("Couldn't find ");
    //     g_print("appID");
    //     g_print("\n");
    //     result = "";
    // }'
    exit(0);
}

typedef struct {
    unsigned char *buffer;
    size_t len;
    size_t buflen;
} get_request;
#define CHUNK_SIZE 2048
size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata) {
    size_t realsize = size * nmemb;
    get_request *req = (get_request *)userdata;

    while (req->buflen < req->len + realsize + 1) {
        req->buffer = realloc(req->buffer, req->buflen + CHUNK_SIZE);
        req->buflen += CHUNK_SIZE;
    }
    memcpy(&req->buffer[req->len], ptr, realsize);
    req->len += realsize;
    req->buffer[req->len] = 0;

    return realsize;
}
const char *getGameNameFromID(char *appID) {
    CURL *curl;
    CURLcode res;
    get_request req = {.buffer = NULL, .len = 0, .buflen = 0};
    curl_global_init(CURL_GLOBAL_DEFAULT);
    curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "GET");
        curl_easy_setopt(curl, CURLOPT_URL,
                         addChar("https://store.steampowered.com/api/appdetails/?appids=", appID));
        req.buffer = malloc(CHUNK_SIZE);
        req.buflen = CHUNK_SIZE;
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&req);
        res = curl_easy_perform(curl);

        GError *error = NULL;
        const char *path = addChar(addChar("$.", appID), ".data.name");
        JsonArray *results = json_node_get_array(
            json_path_query(path, json_from_string(req.buffer, &error), &error));
        if (error != NULL) {
            fprintf(stderr, "%s", error->message);
            free(req.buffer);
            exit(1);
        }
        const gchar *result;
        if (json_array_get_length(results) == 1) {
            result = json_array_get_string_element(results, 0);
        } else {
            g_print("Couldn't find ");
            g_print(appID);
            g_print("\n");
            result = "";
        }
        free(req.buffer);
        return result;
    } else {
        exit(1);
    }
}