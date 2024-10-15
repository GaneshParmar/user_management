// Import Supabase client
import { createClient } from '@supabase/supabase-js';
import conf from '../config/conf';

export class AuthService {
    supabase;

    constructor() {
        this.supabase = createClient(conf.SuperBaseUrl, conf.SuperBaseKey);
    }

    // Sign up with email and password
    async signUp({ email, password }) {
        try {
            const { data, error } = await this.supabase.auth.signUp({
                email: email,
                password: password
            });

            if (!error) {
                return data;
            } else {
                throw new Error(error.message);
            }
        } catch (e) {
            console.log("Error AuthService :: signUp :: ", e.message);
        }
        return null;
    }

    // Login with email and password
    async login({ email, password }) {
        try {
            const { data, error } = await this.supabase.auth.signInWithPassword({
                email: email,
                password: password
            });

            if (!error) {
                return data;
            } else {
                throw new Error(error.message);
            }
        } catch (e) {
            console.log("Error AuthService :: login :: ", e.message);
        }
        return null;
    }

    // Sign up or login with Google OAuth
    async signUpWithGoogle() {
        try {
            const { data, error } = await this.supabase.auth.signInWithOAuth({
                provider: 'google'
            });

            if (!error) {
                return data;
            } else {
                throw new Error(error.message);
            }
        } catch (e) {
            console.log("Error AuthService :: signUpWithGoogle :: ", e.message);
        }
        return null;
    }

    // Login with Google OAuth
    async loginWithGoogle() {
        try {
            const { data, error } = await this.supabase.auth.signInWithOAuth({
                provider: 'google'
            });

            if (!error) {
                return data;
            } else {
                throw new Error(error.message);
            }
        } catch (e) {
            console.log("Error AuthService :: loginWithGoogle :: ", e.message);
        }
        return null;
    }

    // Check if user is already registered
    async isUserRegistered(email) {
        try {
            const { data, error } = await this.supabase.auth.admin.listUsers({
                email: email
            });

            if (!error && data?.users.length > 0) {
                return true; // User is already registered
            } else {
                return false; // User not found
            }
        } catch (e) {
            console.log("Error AuthService :: isUserRegistered :: ", e.message);
        }
        return false;
    }

    async getCurrentUser(){
        try{
            const { data: { user } } = await this.supabase.auth.getUser();
            return user;
        }catch(e){
            console.log("Error AuthService :: getCurrentUser :: ", e.message);
        }

    }


    async logout(){
        try{
            let { error } = await this.supabase.auth.signOut();
            if(error){
                throw new Error(error);
            }
            return true
        }catch(e){
            console.log("Error AuthService :: logout :: ", e.message);
        }

        return false;
       
    }
}

const authService = new AuthService();
export default authService;
