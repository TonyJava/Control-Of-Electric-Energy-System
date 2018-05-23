package kr.lasel.bugking.ijm;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Toast;

public class Loding extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_loding);
    }

    //로그인으로 이동
    public void LoginPage(View v){
        Toast.makeText(this, "로그인화면.", Toast.LENGTH_SHORT).show();

        Intent intent = new Intent(this, Login.class);
        startActivity(intent);
    }
}
