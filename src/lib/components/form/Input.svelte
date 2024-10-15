<script>
  export let type = "text";
  export let value;
  export let placeholder = "";
  export let required = false;
  export let disabled = false;
  export let label = "";
</script>

<div class="grid grid-cols-1 gap-y-1 my-1">
  {#if label != ""}
    <label class="my-1 font-semibold text-base text-slate-500">
      {label}
    </label>
  {/if}
  <input
    class="w-full px-8 py-4 rounded-lg font-medium bg-gray-100 border border-gray-200 placeholder-gray-500 text-sm focus:outline-none focus:border-gray-400 focus:bg-white disabled:bg-gray-300 disabled:text-gray-500 disabled:cursor-not-allowed"
    {...{ type, placeholder, required, disabled }}
    bind:value
  />
</div>

<style>
</style>
