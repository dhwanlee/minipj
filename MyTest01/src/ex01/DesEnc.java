package ex01;

import java.math.BigInteger; 
import javax.crypto.Cipher; 
import javax.crypto.spec.IvParameterSpec; 
import javax.crypto.spec.SecretKeySpec; 
public class DesEnc { 
    public static byte[] enc(String alg, byte[] key, byte[] iv, byte[] msg) throws Exception { 
      SecretKeySpec keySpec = new SecretKeySpec(key, alg); 
      if( alg.equals("DES") ) { 
        alg = "DES/CBC/PKCS5Padding"; 
        } else { 
        alg = "AES/CBC/PKCS5Padding"; 
      } 
    Cipher cipher = Cipher.getInstance(alg); 
    cipher.init(Cipher.ENCRYPT_MODE, keySpec, new IvParameterSpec(iv)); 
    cipher.update( msg ); 
    return cipher.doFinal(); 
    } 
	public static void main(String[] args) throws Exception { 
	  //byte[] key = "1234567890123456".getBytes(); 
	  //byte[] iv = "1234567890123456".getBytes(); 
	  byte[] key = new byte[] { 0x68,0x32,0x68,0x30,0x69,0x31,0x63,0x35 };
	  byte[] iv  = new byte[] { 0x68,0x32,0x68,0x30,0x69,0x31,0x63,0x35 };
	  String pt = "kka07191"; 
	  System.out.println("평문: " + pt); 
	  //byte[] e = enc("AES", key, iv, pt.getBytes()); 
	  //System.out.println("AES 암호화: " + new BigInteger(e).toString(16) ); 
	  //key = "h2h0i1c5".getBytes(); 
	  // iv = "h2h0i1c5".getBytes(); 
	  //e = enc("DES", key, iv, pt.getBytes()); 
	  byte[] e = enc("DES", key, iv, pt.getBytes());
	  System.out.println( "DES 암호화: " + new BigInteger(e).toString(16) ); 
	  System.out.println( "DES2 암호화: " + e.toString() );
	} 
} 