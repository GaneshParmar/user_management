const conf = {
    SuperBaseKey : String(import.meta.env.VITE_SUPERBASE_KEY),
    SuperBaseUrl : String(import.meta.env.VITE_SUPERBASE_URL),
    SuperBaseJwtKey : String(import.meta.env.VITE_SUPERBASE_JWT_KEY),

    Default_User_Photo : "https://th.bing.com/th?id=OIP.VTn0NAxal8BSB5W3ZTSdUAHaHT&w=251&h=248&c=8&rs=1&qlt=90&o=6&dpr=1.6&pid=3.1&rm=2",
    AppName : String(import.meta.env.VITE_APP_NAME)
}

export default conf;