<script>
  export let company_profile;
</script>

<table class="w-full text-md bg-white shadow-md rounded mb-4">
  <tbody>
    <tr class="border-b">
      <th class="text-left p-3 px-5">Name</th>
      <th class="text-left p-3 px-5">Email</th>
      <!-- <th class="text-left p-3 px-5">Role</th> -->
      <th></th>
    </tr>
    {#each company_profile.organizationUsers as profile}
      <tr class="border-b hover:bg-orange-100 bg-gray-100">
        <td class="p-3 px-5"
          ><input
            type="text"
            value={profile.user.full_name}
            class="bg-transparent"
          /></td
        >
        <td class="p-3 px-5"
          ><input
            type="text"
            value={profile.user.email}
            class="bg-transparent"
          /></td
        >
        <!-- Role -->
        <!-- <td class="p-3 px-5">
          <select value={profile.role.name} class="bg-transparent">
            <option value="Financial">Financial</option>
            <option value="Support">Support</option>
            <option value={profile.role.name}>{profile.role.name}</option>
          </select>
        </td> -->
        <!-- <td class="p-3 px-5 flex justify-end"
          ><button
            type="button"
            class="mr-3 text-sm bg-blue-500 hover:bg-blue-700 text-white py-1 px-2 rounded focus:outline-none focus:shadow-outline"
            >Save</button
          ><button
            type="button"
            class="text-sm bg-red-500 hover:bg-red-700 text-white py-1 px-2 rounded focus:outline-none focus:shadow-outline"
            >Delete</button
          ></td
        > -->
      </tr>
    {/each}
  </tbody>
</table>

<style>
</style>
