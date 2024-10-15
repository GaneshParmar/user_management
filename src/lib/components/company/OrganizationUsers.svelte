<script>
  import toast from "svelte-french-toast";
  import organizationUsersTable from "../../supabase/database/organiztionUserTable";
  import userTable from "../../supabase/database/userTable";
  import showToastLoadingWhileFunctionRun from "../../toast/Loading";
  import Button from "../form/Button.svelte";
  import Heading from "../form/Heading.svelte";
  import Input from "../form/Input.svelte";
  import Modal from "../modal/Modal.svelte";
  import CompanyProfile from "./CompanyProfile.svelte";
  import CompanyUser from "./CompanyUser.svelte";
  import OrganizationUserList from "./OrganizationUserList.svelte";
  import { v4 as uuidv4 } from "uuid";

  export let company_profile;

  const addUserToOrganization = async ({
    uuid = uuidv4(),
    email,
    full_name,
    organization_id,
  }) => {
    try {
      const { success, data, error } = await userTable.addUser({
        uuid,
        email,
        full_name,
      });

      if (success) {
        const addUserToOrganization_ =
          await organizationUsersTable.addOrganizationUser({
            uuid: data[0].id,
            organization_id,
            role_id: 5,
            is_admin: false,
          });
        if (addUserToOrganization_ && addUserToOrganization_.success) {
        } else {
          throw new Error(
            addUserToOrganization_ && addUserToOrganization_.error
          );
        }
      } else {
        throw new Error(error.toString());
      }
    } catch (e) {
      console.log("Error while :: addUserToOrganization :: ", e.message);
      throw new Error(e);
    }
  };

  //   Add user modal

  let add_user_modal_open = false;

  //   New user data

  let full_name = "";
  let email = "";
  $: organization_id = company_profile?.profile?.[0]?.organization_id;

  //

  let add_user_modal = {
    error: false,
    icon: false,
    heading: "Add User To Organization",
    successTxt: "Add User",
    cancelTxt: "Close",
    successCallback: () => {
      if (!organization_id) {
        console.log("Invalid organization id");
        return;
      }
    },
    cancelCallback: () => {
      add_user_modal_open = false;
    },
    hidefooter: true,
    theme: "info", // success | warning | info | error
  };

  const AddUser = (e) => {
    e.preventDefault();
    if (!organization_id) {
      toast.error("Invalid organization id");
      return;
    }
    const callback = async () => {
      await addUserToOrganization({ email, full_name, organization_id });
      location.reload();
    };
    showToastLoadingWhileFunctionRun(
      callback,
      toast,
      "Adding user...",
      "Added"
    );
  };
</script>

<div class="grid grid-cols-1 mt-5 w-full">
  <Heading>Organization Users</Heading>
  <!-- component -->
  <div class="text-gray-900">
    <div class="px-3 py-4 flex justify-center">
      <OrganizationUserList {company_profile} />
    </div>
    <Button
      handleClick={() => {
        add_user_modal_open = true;
      }}>Add New Users</Button
    >
    <Modal modal={add_user_modal} bind:isOpen={add_user_modal_open}>
      <form on:submit={AddUser}>
        <div class="grid grid-cols-1 break-words">
          <Input bind:value={full_name} label="Enter name" required />
          <Input bind:value={email} type="email" label="Enter email" required />
          <Button type={"submit"} variant={"success"}>Add User</Button>
        </div>
      </form>
    </Modal>
  </div>
</div>

<style>
</style>
