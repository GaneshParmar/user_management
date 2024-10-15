<script>
  import toast from "svelte-french-toast";
  import Modal from "../modal/Modal.svelte";
  import user_modal from "./usermodalconfig";
  import UsersList from "./UsersList.svelte";
  import showToastLoadingWhileFunctionRun from "../../toast/Loading";
  import departmentUsersTable from "../../supabase/database/departmentUsersTable";
  export let open = true;
  export let users_data = [];
  export let departmentSelected = null;

  let selected_users = [];
  let remove_user_btns = {
    "Remove User": {
      onClick: async () => {
        if (selected_users.length == 0) {
          toast.error("Please select users to remove");
          return;
        }
        if (!departmentSelected || !departmentSelected?.id) {
          toast.error(
            "Please select the valid department or add it under your organization"
          );
          return;
        }

        const removeUsers = async () => {
          for (const selected_user of selected_users) {
            let organization_user_id = selected_user.organization_user_id;
            await departmentUsersTable.removeUserFromDepartment({department_id: departmentSelected.id, organization_user_id});            
          }

          // resetting the ui so it loads
          departmentSelected = {id: -1};
          departmentSelected = departmentSelected;
          open = false;
          selected_users = [];
        };

        showToastLoadingWhileFunctionRun(
          removeUsers,
          toast,
          "Please wait while we remove users from department"
        );
      },
    },
  };
</script>

<Modal bind:isOpen={open} modal={user_modal}>
  {#if users_data.length > 0}
    <UsersList {users_data} bind:selected_users footerBtns={remove_user_btns}/>
  {:else}
    No users present!
  {/if}
</Modal>

<style>
</style>
