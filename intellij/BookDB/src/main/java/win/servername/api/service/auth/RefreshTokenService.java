package win.servername.api.service.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import win.servername.api.repository.auth.RefreshTokenRepository;
import win.servername.entity.auth.RefreshToken;

import java.util.Optional;

@Service
public class RefreshTokenService {
    final RefreshTokenRepository refreshTokenRepository;

    @Autowired
    public RefreshTokenService(RefreshTokenRepository refreshTokenRepository){
        this.refreshTokenRepository = refreshTokenRepository;
    }

    //Create
    public RefreshToken saveRefreshToken(RefreshToken refreshToken){
        return refreshTokenRepository.save(refreshToken);
    }

    //Read
    public Optional<RefreshToken> getRefreshTokenById(long refreshTokenId){
        return refreshTokenRepository.findById(refreshTokenId);
    }

    //Update
    public RefreshToken updateRefreshToken(long refreshTokenId, RefreshToken updatedToken){
        Optional<RefreshToken> optionalRefreshToken = refreshTokenRepository.findById(refreshTokenId);

        if (optionalRefreshToken.isPresent()){
            refreshTokenRepository.deleteById(refreshTokenId);

            RefreshToken refreshToken = optionalRefreshToken.get();

            refreshToken.setRefreshToken(updatedToken.getRefreshToken());
            refreshToken.setUser(updatedToken.getUser());
            refreshToken.setDateProvisioned(updatedToken.getDateProvisioned());
            refreshToken.setExpiryDate(updatedToken.getExpiryDate());
            refreshToken.setLastUsed(updatedToken.getLastUsed());

            return refreshTokenRepository.save(refreshToken);
        }else{
            throw new RuntimeException("Refresh token not found");
        }
    }

    //Delete
    public void deleteRefreshToken(long refreshTokenId){
        refreshTokenRepository.deleteById(refreshTokenId);
    }
}
