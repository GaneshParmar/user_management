import { writable } from "svelte/store";


const authInitialStatus = {
    status : null,
    userData : null,
    profile: null
}

const authStore = writable(authInitialStatus)


export {authStore}