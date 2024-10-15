import { authStore } from "../store";

// Login function that sets the store state to logged in
const login = (userData, profile) => {
    authStore.set({
        status: true, // User is logged in
        userData, // Store user data in the store
        profile
    });
};

// Logout function that resets the store state to logged out
const logout = () => {
    authStore.set({
        status: false, // User is logged out
        userData: null, // Clear user data
        profile: null
    });
};

export { login, logout };
