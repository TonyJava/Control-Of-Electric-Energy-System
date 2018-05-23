package kr.lasel.bugking.ijm;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.widget.PopupMenu;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class Admin extends ActionBarActivity {
    private static String TAG = "USERS";
    private TextView mTextViewResult;
    private String ReceiveURL = "http://ec2-13-125-53-81.ap-northeast-2.compute.amazonaws.com/php/android_adminReceive.php";
    private String SendURL = "http://ec2-13-125-53-81.ap-northeast-2.compute.amazonaws.com/php/android_adminSend.php";
    private String[] Rtotal = {};
    List<String> Ruser_id = new ArrayList<String>();
    List<String> Rauthority = new ArrayList<String>();

    ListView list;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin);

        InsertData task = new InsertData();
        task.execute(TAG, ReceiveURL, "0", "0");
//        mTextViewResult = (TextView)findViewById(R.id.mTextViewResult);
    }

    public void btn_refresh(View v){
        InsertData task = new InsertData();
        task.execute(TAG, ReceiveURL, "0", "0");
    }

    public void btn_refresh(){
        InsertData task = new InsertData();
        task.execute(TAG, ReceiveURL, "0", "0");
    }

    public class CustomList extends ArrayAdapter<String> {
        private final Activity context;
        public CustomList(Activity context){
            super(context, R.layout.listitem, Ruser_id);
            this.context = context;
        }

        @NonNull
        @Override
        public View getView(final int position, @Nullable View convertView, @NonNull ViewGroup parent) {
            LayoutInflater inflater = context.getLayoutInflater();
            View rowView = inflater.inflate(R.layout.listitem, null, true);
            ImageView imageView = (ImageView) rowView.findViewById(R.id.image);
            TextView user_id = (TextView) rowView.findViewById(R.id.user_id);
            TextView authority = (TextView) rowView.findViewById(R.id.authority);
            ImageView btn_send = (ImageView) rowView.findViewById(R.id.btn_send);
            final Button btn_authority = (Button) rowView.findViewById(R.id.btn_authority);

            btn_authority.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    PopupMenu popup = new PopupMenu(Admin.this, v);
                    popup.getMenuInflater().inflate(R.menu.popup_admin, popup.getMenu());
                    popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                        @Override
                        public boolean onMenuItemClick(MenuItem item) {
                            Toast.makeText(getApplicationContext(),item.getTitle(),Toast.LENGTH_SHORT).show();
                            btn_authority.setText(item.getTitle());
                            return true;
                        }
                    });
                    popup.show();
                }
            });

            user_id.setText("ID : " +Ruser_id.get(position));
            imageView.setImageResource(R.drawable.btn_login);
            btn_send.setImageResource(R.drawable.btn_authority);
            btn_send.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Toast.makeText(getApplicationContext(), "권한 부여 " + btn_authority.getText().toString(), Toast.LENGTH_LONG).show();
                    InsertData task = new InsertData();
                    task.execute(TAG, SendURL, btn_authority.getText().toString(), Ruser_id.get(position));
                    btn_refresh();
                }
            });
            authority.setText("현재 권한 : " + Rauthority.get(position));
            return rowView;
        }
    }

    // 데이터 전송 php7
    class InsertData extends AsyncTask<String, Void, String> {
        ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressDialog = ProgressDialog.show(Admin.this, "Please Wait", null, true, true);
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);

            Rtotal = result.split("&");
            int total = Integer.parseInt(Rtotal[0]);

            Ruser_id.removeAll(Ruser_id);
            Rauthority.removeAll(Rauthority);

            for(int i = 0; i< total; i++){
                Ruser_id.add(i, Rtotal[(i*2)+1]);
                Rauthority.add(i, Rtotal[(i+1)*2]);
            }

            CustomList adapter = new CustomList(Admin.this);
            list=(ListView)findViewById(R.id.list);
            list.setAdapter(adapter);

            progressDialog.dismiss();
            Log.d(TAG, "POST response  - " + result);
        }

        @Override
        protected String doInBackground(String... params) {
            String table = (String)params[0];
            String serverURL = (String)params[1];
            String authority = (String)params[2];
            String id = (String)params[3];

            String postParameters = "table=" + table + "&authority=" + authority + "&id=" + id;

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
