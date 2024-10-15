<script>
  import { onMount } from "svelte";
  import Button from "../lib/components/form/Button.svelte";
  import Input from "../lib/components/form/Input.svelte";
  import FormBackground from "../lib/components/FormBackground.svelte";
  import { authStore } from "../lib/store";
  import NextSvg from "../lib/svg/NextSvg.svelte";
  import { navigate } from "svelte-routing";
  import url_path from "../lib/config/pathConfigs";
  import userTable from "../lib/supabase/database/userTable";
  import { callForOnceIfDependencyChange } from "../lib/utils/depenecy";
  import toast, { Toaster } from "svelte-french-toast";
  import RootLayout from "../lib/components/layout/RootLayout.svelte";
  import { login } from "../lib/features/authSlice";

  let profile_update_loading;

  onMount(() => {});

  let profielPageOptions = {
    in_complete: {
      heading: "Complete Profile",
      saveBtnText: "Proceed",
      saveProfile: async () => {
        return await userTable.addUser({ uuid, email, full_name });
      },
      navigate: true,
    },
    update: {
      heading: "Your Profile",
      saveBtnText: "Update Profile",
      saveProfile: async () => {
        return await userTable.updateUser({ uuid, email, full_name });
      },
      navigate: null
    },
  };

  // Select the profile page state upon knowing if the person's profile is added or not

  let profile_state = profielPageOptions["in_complete"];

  const loadProfileOnce = callForOnceIfDependencyChange(() => {
    
    full_name =
      $authStore?.profile?.[0]?.full_name ||
      $authStore?.userData?.user_metadata?.full_name;
    if ($authStore.status && $authStore?.profile != '' && $authStore.profile != null) {
      profile_state = profielPageOptions["update"];
    }
  });

  $: loadProfileOnce($authStore.profile);

  let full_name = "";
  $: email = $authStore?.userData?.email;
  $: uuid = $authStore?.userData?.id;

  // let fla  g = true;
  // $: {
  //   if ($authStore.status) {
  //     // Only one time set the fields
  //     if (flag && (!full_name || full_name == "")) {
  //       full_name =
  //         $authStore?.profile?.full_name ||
  //         $authStore?.userData?.user_metadata?.full_name;
  //       flag = false;
  //     }
  //   }
  // }

  let form_error = "";

  const updateProfile = async () => {
    try{

      profile_update_loading = true;
  
      const user_added = await profile_state.saveProfile();
  
      profile_update_loading = false;
  
      if (user_added) {
        if (profile_state.navigate) {
          navigate("/");
        }
      } else {
        form_error = "Something went wrong. Please try again later.";
        setTimeout(() => {
          form_error = "";
        }, 2000);
        throw new Error(form_error)
      }
    }catch(e){
      console.log("Error :: updateProfile ::  ",e.message)
      throw new Error(e)
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    toast.promise(updateProfile(), {
      loading: "Saving...",
      success: "Profile saved successfully!",
      error: "Could not save.",
    });
  };

 

  $: {
    if (!($authStore.status ?? true)) {
      navigate(url_path.login);
    }
  }
</script>
<RootLayout pageHeading={"/Profile"}>
  
  <FormBackground error={form_error}>
    <form on:submit={handleSubmit}>
      <div class="gird grid-cols-1">
        <h1 class="text-center text-3xl font-bold">{profile_state.heading}</h1>
        <div class="grid grid-cols-1">
          <div class="grid grid-cols-1 m-4 gap-y-2">
            <Input
              placeholder="Enter your full name"
              bind:value={full_name}
              required={true}
            />
            <Input
              placeholder="Enter your email address"
              type="email"
              bind:value={email}
              required={true}
              disabled={true}
            />
            <Button type={"submit"} loading={profile_update_loading}>
              <div class="flex items-center text-white">
                {profile_state.saveBtnText}
                <NextSvg />
              </div>
            </Button>
          </div>
        </div>
      </div>
    </form>
  </FormBackground>
</RootLayout>

<style>
</style>
