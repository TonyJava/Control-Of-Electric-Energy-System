package kr.lasel.bugking.ijm;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by gwongimun on 2017. 9. 26..
 */

public class Login extends AppCompatActivity {
    private static String TAG = "Login";
    public static String authority;
    EditText Login_id, Login_pw;
    String sId, sPw;

//    private TextView mTextViewResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);


        // id, pw 초기화
        Login_id = (EditText) findViewById(R.id.Login_ID);
        Login_pw = (EditText) findViewById(R.id.Login_PWD);

//        mTextViewResult = (TextView)findViewById(R.id.textView_main_result);

    }

    //로그인으로 이동
    public void btn_login(View v){
        // login을 위한 데이터 저장

        // 입력한 데이터가 맞다면 로그인
        try{
            sId = Login_id.getText().toString();
            sPw = Login_pw.getText().toString();
        }catch (NullPointerException e)
        {
            Log.e("err",e.getMessage());
        }

        if(sId.isEmpty() || sPw.isEmpty()){
            Toast.makeText(this, "로그인정보를 입력해주세요.", Toast.LENGTH_SHORT).show();

        } else{
            Login_id.setText("");
            Login_pw.setText("");
            InsertData task = new InsertData();
            task.execute(sId, sPw);
        }


    }

    //회원가입으로 이동
    public void btn_To_registration(View v){
        Toast.makeText(this, "회원가입 페이지로 이동.", Toast.LENGTH_SHORT).show();

        Intent intent = new Intent(this, Registration.class);
        startActivity(intent);
    }

    // 데이터 전송 php7
    class InsertData extends AsyncTask<String, Void, String>{
        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = ProgressDialog.show(Login.this, "Please Wait", null, true, true);
        }


        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

            progressDialog.dismiss();
            authority = "0";
//            mTextViewResult.setText(result);
            // php결과가 [연결성공]1이면 로그인
            if(result.equals("[연결성공]1")){
                Toast.makeText(Login.this, "일반회원로그인",Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(Login.this, MainMenu.class);
                startActivity(intent);
            } else if (result.equals("[연결성공]0001")) {
                Toast.makeText(Login.this, "등록되지 않은 ID입니다.", Toast.LENGTH_SHORT).show();
            } else if (result.equals("[연결성공]0")) {
                Toast.makeText(Login.this, "회원정보를 확인해주세요.", Toast.LENGTH_SHORT).show();
            } else if (result.equals("[연결성공]0002")){
                Toast.makeText(Login.this, "관리자에게 권한을 받으세요.", Toast.LENGTH_SHORT).show();
            } else if(result.equals("[연결성공]0099")){
                authority = "99";
                Toast.makeText(Login.this, "관리자로 로그인하셨습니다.", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(Login.this, MainMenu.class);
                startActivity(intent);
            } else{
                Toast.makeText(Login.this, "인터넷 연결상태를 확인해 주세요.", Toast.LENGTH_SHORT).show();
            }
            Log.d(TAG, "POST response  - " + result);
        }


        @Override
        protected String doInBackground(String... params) {

            String id = (String)params[0];
            String pwd = (String)params[1];

            String serverURL = "http://ec2-13-125-53-81.ap-northeast-2.compute.amazonaws.com/php/android_login.php";
            String postParameters = "id=" + id + "&pwd=" + pwd;

            try {

                URL url = new URL(serverURL);
                HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();

                httpURLConnection.setReadTimeout(5000);
                httpURLConnection.setConnectTimeout(5000);
                httpURLConnection.setRequestMethod("POST");
                //httpURLConnection.setRequestProperty("content-type", "application/json");
                httpURLConnection.setDoInput(true);
                httpURLConnection.connect();


                OutputStream outputStream = httpURLConnection.getOutputStream();
                outputStream.write(postParameters.getBytes("UTF-8"));
                outputStream.flush();
                outputStream.close();


                int responseStatusCode = httpURLConnection.getResponseCode();
                Log.d(TAG, "POST response code - " + responseStatusCode);

                InputStream inputStream;
                if(responseStatusCode == HttpURLConnection.HTTP_OK) {
                    inputStream = httpURLConnection.getInputStream();
                }
                else{
                    inputStream = httpURLConnection.getErrorStream();
                }


                InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "UTF-8");
                BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                StringBuilder sb = new StringBuilder();
                String line = null;

                while((line = bufferedReader.readLine()) != null){
                    sb.append(line);
                }


                bufferedReader.close();
                return sb.toString();


            } catch (Exception e) {

                Log.d(TAG, "InsertData: Error ", e);

                return new String("Error: " + e.getMessage());
            }

        }
    }
}

