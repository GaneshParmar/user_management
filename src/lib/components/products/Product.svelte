<script>
  import { navigate } from "svelte-routing";
  import { authStore } from "../../store";
  import organizationUsersTable from "../../supabase/database/organiztionUserTable";
  import url_path from "../../config/pathConfigs";

  export let product_name = "Cybersecurity";
  export let product_img =
    "https://th.bing.com/th/id/OIP.lVK524h45oLYBbsyyhI1FwHaEk?w=296&h=182&c=7&r=0&o=5&dpr=1.6&pid=1.7";
  export let buy_link = "#";

  const userIsInOrganization = async (id) => {
    const { data } = await organizationUsersTable.getOrganizationUser(id);

    if (data?.length > 0) {
      return true;
    } else {
      return false;
    }
  };

  const handleBuyProduct = async () => {
    // 1) check if the user has company under his name
    const user_is_in_organization = await userIsInOrganization(
      $authStore.userData.id
    );

    // if he is not take him to add company page..
    if (!user_is_in_organization) {
      navigate(url_path.company_registration);
    } else {
      alert("Purchased successfully");
    }
  };
</script>

<div
  class="min-w-12 border rounded hover:scale-105 grid grid-cols-1 shadow-lg p-2"
>
  <img src={product_img} />
  <h4 class="text-center">
    {product_name}
  </h4>
  <div class="text-right mt-2">
    <a href={`${$authStore.status ? buy_link : "/login"}`}>
      <button
        class="py-2 px-4 rounded bg-blue-600 text-white w-28"
        on:click={handleBuyProduct}>Buy</button
      >
    </a>
  </div>
</div>

<style>
</style>
