<?php
  defined('BASEPATH') OR exit('No direct script access allowed');

  class Admin extends CI_Controller {

    public function adminLoad(){
      $this->load->model('Bee', '', true);

      $token=isset($_POST['token']) ? $_POST['token'] : '';

      if($token!=''){
        $query=$this->Bee->chktoken($token, true);

        if($query){
          $newToken=$this->Bee->publishtoken($query->row()->users_id);

          $query=$this->Bee->adminLoad();

          $result=array();
          foreach ($query->result_array() as $row){
            array_push($result, $row);

          }

          $this->_JSONParsing(200, 'Success', $result, $newToken);

        } else{
            $this->_JSONParsing(305, 'Your token has expired.', '', '');
        }
      } else {
        $this->_JSONParsing(300, 'Parameter is invalid', '', '');

      }
    }

    public function adminUpdate(){
      $this->load->model('Bee', '', true);

      $token=isset($_POST['token']) ? $_POST['token'] : '';
      $id=isset($_POST['id']) ? $_POST['id'] : '';
      $level=isset($_POST['level']) ? $_POST['level'] : '';

      if($token!='' && $id!='' && $level!=''){
        $query=$this->Bee->chktoken($token, true);

        if($query){
          $newToken=$this->Bee->publishtoken($query->row()->users_id);
          $this->Bee->adminUpdate($id, $level);
          $this->_JSONParsing(200, 'Success', '', $newToken);

        } else{
          $this->_JSONParsing(305, 'Your token has expired.', '', '');

        }
      } else {
        $this->_JSONParsing(300, 'Parameter is invalid', '', '');
      }
    }

      private function _JSONParsing($code, $message, $data, $token){
          $dataJSON=array();
          $dataJSON['code']=$code;
          $dataJSON['message']=$message;
          $dataJSON['data']=$data;
          $dataJSON['token']=$token;

          $this->load->view('jsonParsing', $dataJSON);
      }

    private function _encodingToJSON($data){
      return json_encode($data);
    }

    private function _pwd_BCRYPT($pwd)
    {
      $options = [
          'cost' => 12,
      ];

      $pwd=password_hash($pwd, PASSWORD_BCRYPT, $options);
      return $pwd;
    }
  }
?>
