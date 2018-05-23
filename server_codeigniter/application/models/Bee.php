<?php
  class Bee extends CI_Model{
  //컨트롤러와 디비를 연결해주는 모델, bugking.... 벌레 중 bee가 꿀을 갖다주는 것처럼..
    function __construct()
    {
        parent::__construct();
    }

    public function registration($id, $pwd){
      $sql = "INSERT IGNORE INTO users (user_id, user_pwd, level, try, modify, last_login, reg_date)
              VALUES (?, ?, 0, 0, now(), now(), now())";
      $this->db->query($sql, array($id, $pwd));

      // insert한 개수가 0으면 중복, 1이면 insert한 것임.
      $num_inserts = $this->db->affected_rows();

      if($num_inserts > 0){
        return true;
      } else{
        return false;
      }
    }

    public function login($id){
      $sql="SELECT * FROM users WHERE user_id = ?";
      $query=$this->db->query($sql, array($id));

      $num_inserts = $this->db->affected_rows();
      if($num_inserts > 0){
        return $query;
      } else{
        return false;
      }
    }

    public function pwdtry($ok, $id){
      if($ok){
        $sql="UPDATE users SET try=0 WHERE user_id=?";
      } else{
        $sql="UPDATE users SET try=try+1 WHERE user_id=?";
      }

      $this->db->query($sql, array($id));
    }

    public function publishtoken($id){
      $tokendata = $id + date("YmdHis") + $id + mt_rand(1,9999);
      $token = hash('sha256', $tokendata);

      $sql = "INSERT INTO user_session (token, token_date, token_expire, users_id )
              VALUES (?, now(), now() + INTERVAL 1 DAY, ?)
              ON DUPLICATE KEY
              UPDATE token = ?, token_date = now(), token_expire = now()+ INTERVAL 1 DAY";

      $this->db->query($sql, array($token, $id, $token));
      return $token;
    }

    public function chktoken($token, $admin=false){
      // 일반 토큰과 관리자 토큰을 구분한 것이다.
      if($admin){
        $sql = "SELECT *
                FROM users
                LEFT JOIN user_session
                ON users.id = user_session.users_id
                WHERE now() < token_expire AND token=? AND level=99";
      } else{
        $sql = "SELECT *
                FROM users
                LEFT JOIN user_session
                ON users.id = user_session.users_id
                WHERE now() < token_expire AND token=?";
      }
      $query=$this->db->query($sql, array($token));

      $num_inserts = $this->db->affected_rows();
      if($num_inserts > 0){
        //$this->publishtoken($query->row()->users_id);

        return $query;

      } else{
        return false;

      }
    }

    public function adminLoad(){
      $sql = "SELECT user_id, level FROM users WHERE level < 99";
      $query = $this->db->query($sql);

      return $query;
    }

    public function adminUpdate($id, $level){
      $sql = "UPDATE users SET level = ? WHERE user_id = ?";
      $this->db->query($sql, array($level, $id));
    }

    public function askdb($building){
      $sql = "SELECT T1.location, count(*) AS total,
         IFNULL((SELECT count(*) FROM addy T2 WHERE state=1 AND T2.location=T1.location limit 1),0) AS oncount
         FROM addy T1 where building=? GROUP BY location ORDER BY id ASC";

      $query=$this->db->query($sql, array($building));

      return $query->result_array();
    }

    public function turnoff($location){
      $sql="UPDATE addy SET shutdown = '0' WHERE location = ?";
      $this->db->query($sql, array($location));

    }

    public function offlog($id, $location){
      $sql="INSERT INTO user_history (last_shutdown, location, users_id)
            VALUES (now(), ?, ?)";
      $this->db->query($sql, array($location, $id));
    }

    public function askExist($macAddress){
      $sql="SELECT * FROM addy WHERE address = ?";
      $query=$this->db->query($sql, array($macAddress));

      $num_inserts = $this->db->affected_rows();

      if($num_inserts > 0){
          return $query;
      } else{
          return false;
      }
    }

      public function insertAddress($macAddress, $location){
          $building = substr($location, 0, 1);
          $sql="INSERT into addy (address, state, location, shutdown, reg_date, building) 
                values (?, 1, ?, 1, now(), ?)";
          $query=$this->db->query($sql, array($macAddress, $location, $building));

          return $query;
      }

      public function updateState($macAddress, $state){
          $sql="UPDATE addy SET state=? WHERE address=?";
          $query=$this->db->query($sql, array($state, $macAddress));

          return $query;
      }

      public function updateShutdown($macAddress){
          $sql="UPDATE addy SET state=1, shutdown=1 WHERE address=?";
          $query=$this->db->query($sql, array($macAddress));

          return $query;
      }

      public function eqfind($longitude, $latitude, $distance) {
          $sql="SELECT location, longitude, latitude
                , (6371*acos(cos(radians(?))*cos(radians(latitude))*cos(radians(longitude)
	            -radians(?))+sin(radians(?))*sin(radians(latitude))))AS distance
                FROM test HAVING distance <= ? ORDER BY distance LIMIT 0,300";
          $DB2 = $this->load->database('earthquake', TRUE);
          $query=$DB2->query($sql, array($latitude, $longitude, $latitude, $distance));

          return $query;
      }

      public function eqinfo($longitude, $latitude){
          $sql="SELECT location, detail, acceptable FROM test WHERE latitude=? AND longitude=?";
          $DB2 = $this->load->database('earthquake', TRUE);
          $query=$DB2->query($sql, array($latitude, $longitude));

          return $query;
      }

      public function eqtest($longitude, $latitude) {
          $sql="SELECT location, longitude, latitude
                , (6371*acos(cos(radians(?))*cos(radians(latitude))*cos(radians(longitude)
	            -radians(?))+sin(radians(?))*sin(radians(latitude))))AS distance
                FROM test HAVING distance <= 5 ORDER BY distance LIMIT 0,300";
          $DB2 = $this->load->database('earthquake', TRUE);
          $query=$DB2->query($sql, array($latitude, $longitude, $latitude));

          return $query;
      }
  }
?>




















