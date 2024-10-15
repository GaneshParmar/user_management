<script>
  import toast, { ToastBar } from "svelte-french-toast";

  export let error = "";
  export let loading = false;
  export let widthIncrease = false;
  $:{

    if(error && error != ''){
      try{
        console.log(error)
        toast.error(error.toString());
      }catch (e){
        console.log(e);
      }
    }
  }
</script>

<div class="min-h-screen bg-gray-100 text-gray-900 flex justify-center">
  <div
    class="max-w-screen-xl m-0 sm:m-20 bg-white shadow sm:rounded-lg flex justify-center flex-1 relative"
  >
    {#if loading}
      <div class="absolute w-full h-full bg-slate-200 z-10 flex justify-center items-center">
        <span class="text-2xl font-bold">
          Loading...
        </span>
      </div>  
    {/if}
    <div class={`${ !widthIncrease ?'lg:w-1/2 xl:w-5/12' : 'w-full'} p-6 sm:p-12`}>
      <slot />
      {#if error}
        <p class="text-red-500 text-center">
          {typeof error == "object" ? JSON.stringify(error) : error}
        </p>
      {/if}
    </div>
  </div>
</div>

<style>
</style>
