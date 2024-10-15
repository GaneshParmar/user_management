<script>
  import { Router, Link, Route, navigate } from "svelte-routing";
  import Home from "./routes/Home.svelte";
  import '@fortawesome/fontawesome-free/css/all.min.css'
  import Products from "./routes/Products.svelte";
  import Login from "./lib/components/Login.svelte";
  import Register from "./lib/components/Register.svelte";
  import { onMount } from "svelte";
  import userTable from "./lib/supabase/database/userTable";
  import { authStore } from "./lib/store";
  import UserProfile from "./routes/UserProfile.svelte";
  import authService from "./lib/supabase/auth";
  import { login, logout } from "./lib/features/authSlice";
  import CreateCompany from "./routes/CreateCompany.svelte";
  import '@fortawesome/fontawesome-free/css/all.min.css'
  import { Toaster } from "svelte-french-toast";
  import { callForOnceIfDependencyChange } from "./lib/utils/depenecy";
  import url_path from "./lib/config/pathConfigs";
  import CompanyRoute from "./routes/CompanyRoute.svelte";

  // import About from "./routes/About.svelte";
  // import Blog from "./routes/Blog.svelte";

  export let url = "";

  onMount(async() => {
    const userData = await authService.getCurrentUser();
    if(userData){
        login(userData);
    }else{
      logout();
    }
  });


  const checkProfileForUser = async(user_type) =>{
    switch (user_type) {
      case 'admin':

      if($authStore.status){

        const user_row = await userTable.getUser($authStore?.userData?.id);
        
        login($authStore?.userData, user_row);
        // If the condition is true means the record is not being saved so take him to complete his profile
        if(!user_row || user_row.length == 0){
          navigate('/profile');
        }
      }
        break;
    
      default:
        break;
    }
  }

  async function checkUserProfileIsComplete(){
    const user_type = 'admin';

    checkProfileForUser(user_type)

  }
  const UserProfileComplete = callForOnceIfDependencyChange(()=>{
    checkUserProfileIsComplete();

  });

  $: UserProfileComplete($authStore.status);

</script>

<Toaster />
<Router {url}>
  <div>
    <Route path={url_path.home}><Products /></Route>
    <Route path={url_path.user_register}><Register /></Route>
    <Route path={url_path.login}><Login /></Route>
    <Route path={url_path.company_registration}><CreateCompany /></Route>
    <Route path={url_path.company_page}><CompanyRoute /></Route>
    <Route path={url_path.profile_page}><UserProfile /></Route>
  </div>
</Router>
