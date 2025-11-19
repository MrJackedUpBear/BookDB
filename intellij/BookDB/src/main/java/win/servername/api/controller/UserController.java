package win.servername.api.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import win.servername.api.exceptions.InvalidCredentialsException;
import win.servername.api.service.UserService;
import win.servername.entity.auth.RefreshToken;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import static win.servername.Constants.*;

@RestController
@RequestMapping(API_MAPPING)
public class UserController {
    private final UserService userService;

    @Autowired
    public UserController(UserService userService){
        this.userService = userService;
    }

    @GetMapping("/login")
    public String getRefreshToken(@RequestHeader("Authorization") String authHeader,
                                                  HttpServletResponse response){
        int loginStatus = 0;
        RefreshToken refreshToken = new RefreshToken();

        //TODO: Check login credentials and generate token
        try{
            authHeader = authHeader.substring("basic ".length());
        }catch(Exception e){
            throw new InvalidCredentialsException("Authentication Error. Usage Example: " +
                    "\"Basic base64.Encode(username:password)\"");
        }

        byte[] authValues = Base64.getDecoder().decode(authHeader);

        String usernameAndPassword = new String(authValues, StandardCharsets.UTF_8);

        String[] temp = usernameAndPassword.split(":", 2);;

        if (temp.length != 2){
            throw new InvalidCredentialsException("Authentication Error. Usage Example: " +
                    "\"Basic base64.Encode(username:password)\"");
        }

        String username = temp[0];
        String password = temp[1];

        loginStatus = userService.login(username, password);

        refreshToken = switch (loginStatus) {
            case INCORRECT_PASSWORD -> throw new InvalidCredentialsException("Incorrect Password.");
            case INCORRECT_USERNAME -> throw new InvalidCredentialsException("Incorrect Username.");
            case SUCCESSFUL_LOGIN -> userService.getRefreshToken(username);
            default -> refreshToken;
        };

        long timeUntilExpiry = refreshToken.getExpiryDate().getTime();

        Cookie cookie = new Cookie("RefreshToken", refreshToken.getRefreshToken());
        cookie.setMaxAge((int) timeUntilExpiry);
        cookie.setSecure(true);
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        response.addCookie(cookie);

        return "Successful Login!";
    }
}
