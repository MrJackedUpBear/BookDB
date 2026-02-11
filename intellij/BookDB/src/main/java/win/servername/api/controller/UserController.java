package win.servername.api.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;
import win.servername.api.exceptions.InvalidCredentialsException;
import win.servername.api.service.BookService;
import win.servername.api.service.JwtService;
import win.servername.api.service.UserService;
import win.servername.entity.auth.RefreshToken;
import win.servername.entity.auth.User;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;

import static win.servername.Constants.*;

@RestController
@RequestMapping(API_MAPPING)
@RequiredArgsConstructor
public class UserController {
    private UserService userService;
    private AuthenticationManager authenticationManager;
    private JwtService jwtService;

    @Autowired
    public UserController(JwtService jwtService, UserService userService, AuthenticationManager authenticationManager){
        this.userService = userService;
        this.authenticationManager = authenticationManager;
        this.jwtService = jwtService;
    }

    @GetMapping("/login")
    public ResponseEntity<HashMap<String, String>> getRefreshToken(@RequestHeader("Authorization") String authHeader,
                                                                   @RequestHeader("User-Agent") String userAgent,
                                                                   HttpServletResponse response){
        int loginStatus = 0;
        RefreshToken refreshToken = new RefreshToken();

        //TODO: Check login credentials and generate token
        try{
            authHeader = authHeader.substring("basic ".length());
        }
        catch(Exception e){
            throw new InvalidCredentialsException("Authentication Error. Usage Example: " +
                    "\"Basic base64.Encode(username:password)\"");
        }

        byte[] authValues = Base64.getDecoder().decode(authHeader);

        String username;

        try{
            username = new String(authValues, StandardCharsets.UTF_8).split(":", 2)[0];
        }catch (Exception e){
            throw new InvalidCredentialsException("Authentication Error. Usage Example: " +
                    "\"Basic base64.Encode(username:password)\"");
        }

        byte[] password = extractPassword(authValues);

        Arrays.fill(authValues, (byte) '\0');

        //Old code. We can use the authentication manager to verify login.
        //loginStatus = userService.login(username, password);

        //Arrays.fill(password, (byte) '\0');

        //refreshToken = switch (loginStatus) {
        //    case INCORRECT_PASSWORD -> throw new InvalidCredentialsException("Incorrect Password.");
        //    case INCORRECT_USERNAME -> throw new InvalidCredentialsException("Incorrect Username.");
        //    case SUCCESSFUL_LOGIN -> userService.getRefreshToken(username);
        //    default -> refreshToken;
        //};

        System.out.println("Verifying login...");
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username, new String(password, StandardCharsets.UTF_8))
        );



        System.out.println("Checking if authenticated...");
        if (authentication.isAuthenticated()){
            refreshToken = userService.getRefreshToken(username);

            HashMap<String, String> token = new HashMap<>();
            token.put("AccessToken", jwtService.generateToken(username));

            if (userAgent.contains("Dart")){
                token.put("RefreshToken", refreshToken.getRefreshToken());
            }
            else{
                long timeUntilExpiry = refreshToken.getExpiryDate().getTime() - System.currentTimeMillis();

                Cookie cookie = new Cookie("RefreshToken", refreshToken.getRefreshToken());
                cookie.setMaxAge((int) timeUntilExpiry);
                cookie.setSecure(true);
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                response.addCookie(cookie);
            }

            return ResponseEntity.ok(token);
        }else{
            throw new UsernameNotFoundException("Invalid request");
        }

        //Previous code. Reworking above...
        /*

         */
    }

    @GetMapping("/refresh")
    public String refreshAccessToken(@CookieValue(name = "RefreshToken") String token){
       User user = userService.verifyRefreshToken(token);

       if (user == null){
           throw new InvalidCredentialsException("Bad Refresh Token");
       }

       return jwtService.generateToken(user.getUsername());
   }

    byte[] extractPassword(byte[] input){
        int length = input.length;
        int colonIndex = 0;

        for (int i = 0; i < length; i++){
            if (input[i] == ':'){
                colonIndex = i;
                i = length;
            }
        }

        if (colonIndex == 0 || colonIndex == length - 1){
            throw new InvalidCredentialsException("Authentication Error. Usage Example: " +
                    "\"Basic base64.Encode(username:password)\"");
        }

        length = length - colonIndex - 1;

        byte[] result = new byte[length];

        System.arraycopy(
                input,
                colonIndex + 1,
                result,
                0,
                length
        );

        Arrays.fill(input, (byte) '\0');

        return result;
    }
}
