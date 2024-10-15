<script>
  import Heading from "../form/Heading.svelte";
  import Input from "../form/Input.svelte";

    export let company_data;

    $: company_data = Array.isArray(company_data) ? company_data : [company_data];
</script>

<div class="grid grid-cols-1">
  <Heading>Company</Heading>
  {#if company_data}
    {#each company_data as company}
      <Input value={company.name} label={"Comapany Name"} disabled/>
    {/each}
  {/if}
</div>

<style>
</style>
