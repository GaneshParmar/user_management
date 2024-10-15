<script>
  // @ts-nocheck
  
    import toast from "svelte-french-toast";
  
    export let handleClick = () => {};
    export let type = 'button';
    export let loading = false;
    export let variant = 'primary'; // Default variant
  
    // Define different button styles for each variant
    const buttonStyles = {
      primary: {
        bg: "bg-indigo-500",
        hover: "hover:bg-indigo-700",
        text: "text-gray-100",
      },
      secondary: {
        bg: "bg-gray-500",
        hover: "hover:bg-gray-700",
        text: "text-gray-100",
      },
      success: {
        bg: "bg-green-500",
        hover: "hover:bg-green-700",
        text: "text-gray-100",
      },
      warning: {
        bg: "bg-yellow-500",
        hover: "hover:bg-yellow-700",
        text: "text-gray-900",
      },
      danger: {
        bg: "bg-red-500",
        hover: "hover:bg-red-700",
        text: "text-gray-100",
      }
    };
  
    // Compute the selected styles based on the variant
    $: selectedStyle = buttonStyles[variant];
  </script>
  
  <button
    class={`mt-3 tracking-wide font-semibold ${selectedStyle.bg} ${selectedStyle.text} w-full py-4 rounded-lg ${selectedStyle.hover} transition-all duration-300 ease-in-out flex items-center justify-center focus:shadow-outline focus:outline-none disabled:bg-slate-500 disabled:text-gray-400 disabled:cursor-not-allowed`}
    {...{type}}
    on:click={handleClick}
    disabled={loading}
  >
    <span class="ml-3"><slot /></span>
  </button>
  
  <style>
  </style>
  