package kr.lasel.bugking.ijm;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.Toast;

/**
 * Created by gwongimun on 2017. 9. 29..
 */

public class MainMenu extends AppCompatActivity {
    private ImageView ImageViewID;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mainmenu);

        ImageView btn_admin = (ImageView)findViewById(R.id.btn_admin);
        btn_admin.setVisibility(View.GONE);
        if(Login.authority.equals("99")){
            btn_admin.setVisibility(View.VISIBLE);
        }

    }

    // 컴퓨터 끄기
    public void MoveToRoom(View v){
        int id = v.getId();
        switch (id){
            case R.id.btn_soon_01 :
                Toast.makeText(this, "승연관이동", Toast.LENGTH_SHORT).show();
                break;
            case R.id.btn_soon_02 :
                Toast.makeText(this, "월당관이동", Toast.LENGTH_SHORT).show();
                break;
            case R.id.btn_soon_03 :
                Toast.makeText(this, "일만관이동", Toast.LENGTH_SHORT).show();
                break;
            case R.id.btn_soon_04 :
                Toast.makeText(this, "열림관이동", Toast.LENGTH_SHORT).show();
                break;
            case R.id.btn_soon_05 :
                Toast.makeText(this, "나눔관이동", Toast.LENGTH_SHORT).show();
                break;
            case R.id.btn_soon_06 :
                Toast.makeText(this, "이천환관이동", Toast.LENGTH_SHORT).show();
                Intent intent = new Intent(this, IJM06.class);
                startActivity(intent);
                break;
            case R.id.btn_soon_07 :
                Toast.makeText(this, "새천년관이동", Toast.LENGTH_SHORT).show();
                break;
            case R.id.btn_soon_08 :
                Toast.makeText(this, "중앙도서관이동", Toast.LENGTH_SHORT).show();
                break;
            case R.id.btn_soon_12 :
                Toast.makeText(this, "미가엘관이동", Toast.LENGTH_SHORT).show();
                break;
        }
    }

    public void MoveToNotice(View v){
        Toast.makeText(this, "전기세 현황으로 이동", Toast.LENGTH_SHORT).show();
    }

    public void btn_admin(View v){
        Toast.makeText(this, "관리자 페이지로 이동", Toast.LENGTH_SHORT).show();

        Intent intent = new Intent(this, Admin.class);
        startActivity(intent);
    }

}