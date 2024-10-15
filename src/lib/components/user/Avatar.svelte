<script>
  import { faXmark } from '@fortawesome/free-solid-svg-icons';
  
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
  import { Link, navigate } from "svelte-routing";
  import authService from "../../supabase/auth";
  import { logout } from "../../features/authSlice";
  import conf from "../../config/conf";
  import url_path from '../../config/pathConfigs';

  export let userProfileImage = "";
  export let userDisplayName = "";
  export let userEmail = "";

  let nav_open = false;

  const handleLogout = async () => {
    try {
      const logout_ = await authService.logout();
      navigate("/", { replace: true });
      logout();
    } catch (e) {
      console.log("Error Logout Avatar page :: handleLogout :: ", e.message);
    }
  };
</script>

<div class="flex justify-end">
  <div
    class="grid grid-cols-1 w-fit max-w-2xl right-0 relative mx-auto md:mx-3 py-2 px-4"
  >
    <!-- <div class="grid grid-cols-1">
                <h3>{userDisplayName}</h3>
                <p>{userEmail}</p>
            </div> -->
    <div class="rounded-full overflow-hidden border">
      <button
        class="hover:scale-125 flex justify-center items-center w-10 h-10"
        on:click={() => {
          nav_open = !nav_open;
        }}
      >
        {#if !nav_open}
          <img
            src={userProfileImage || conf.Default_User_Photo}
            alt="user_img"
            on:error={(e) => {
              e.target.src = conf.Default_User_Photo;
            }}
          />
        {:else}
          <i class="fa-solid fa-xmark"></i>
        {/if}
      </button>
      <div
        class={`absolute bg-slate-200 box-border rounded right-0 overflow-hidden transition-all  ease-in z-20 ${nav_open ? "max-h-auto" : "max-h-0 "}`}
      >
        <ul class="w-28 p-3">
          <li class="border-gray-600 border-b p-2">
            <Link to={url_path.profile_page}>Profile</Link>
          </li>
          <li class="border-gray-600 border-b p-2">
            <Link to={url_path.company_page}>Company</Link>
          </li>
          <hr />
          <li class="border-gray-600 border-b p-2">
            <button
              class="bg-red-400 rounded-lg text-white p-2"
              on:click={handleLogout}>Logout</button
            >
          </li>
        </ul>
      </div>
    </div>
  </div>
</div>

<style>
</style>
