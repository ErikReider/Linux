from sys import argv
from typing import List
from i3ipc import Connection

i3 = Connection()

i3_workspaces = i3.get_workspaces()
i3_workspaces.sort(key=lambda x: x.ipc_data["num"])
workspaces: List[int] = [e.ipc_data["num"] for e in i3_workspaces]

current_ws = 1
for ws in i3_workspaces:
    if ws.ipc_data["focused"]:
        current_ws = ws.ipc_data["num"]


def insert_ws(new_num: int):
    # Check if workspace num already exists
    try:
        # Renames the next workspaces to n+1 when needed
        def rename_ws(new_num: int, index: int):
            if workspaces[index] + 1 == workspaces[index + 1]:
                rename_ws(new_num, index + 1)

            i3.command("rename workspace number {} to {}"
                       .format(workspaces[index], workspaces[index] + 1))

        rename_ws(new_num, workspaces.index(new_num))
    except Exception as _:
        # Not found
        pass

    # Create the new workspace
    i3.command("workspace number {}".format(new_num))


match argv[1]:
    case "--insert-ws-next":
        insert_ws(current_ws + 1)
    case "--insert-ws-prev":
        insert_ws(current_ws)
    case _:
        print("Unknown command")
        exit(1)
