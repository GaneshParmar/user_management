<script>
  import { onMount } from "svelte";
  import Avatar from "../user/Avatar.svelte";
  import { authStore } from "../../store";
  import { Link } from "svelte-routing";
  import conf from "../../config/conf";

  export let pageHeading = "";
  export let show_search_products = false;
  export let wrapIn = false;

  $: isLoggedIn = $authStore.status;
  $: userData = $authStore.userData;
  // onMount(async() => {
  //   userData = await authService.getCurrentUser();
  //   if(userData){
  //       login(userData);
  //   }
  // });
</script>

<div class="grid grid-cols-1 max-w-5xl mx-auto">
  <div
    class="flex p-4 justify-between flex-col gap-2 md:flex-row items-center justify-center"
  >
    <Link to="/">
      <h3 class="text-3xl font-bold">
        {conf.AppName}
        {pageHeading}
      </h3>
    </Link>
    {#if show_search_products}
      <div class="flex items-center gap-2 w-full max-w-xl">
        <i class="fa-solid fa-magnifying-glass absolute ml-2"></i>
        <input
          class="w-full px-8 py-4 rounded-lg font-medium bg-gray-100 border border-gray-200 placeholder-gray-500 text-sm focus:outline-none focus:border-gray-400 focus:bg-white"
          type="email"
          placeholder="Search Products"
        />
      </div>
    {/if}
    {#if isLoggedIn}
      <Avatar
        userProfileImage={userData?.user_metadata?.picture}
        userEmail={userData?.email}
        userDisplayName={userData?.user_metadata?.full_name ||
          userData?.user_metadata?.name}
      />
    {/if}
  </div>
</div>
{#if wrapIn}
  <div class="grid grid-cols-1 max-w-5xl mx-auto">
    <slot />
  </div>
{:else}
<slot />
{/if}

<style>
</style>
