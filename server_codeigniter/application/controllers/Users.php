<?php
  defined('BASEPATH') OR exit('No direct script access allowed');

  class Users extends CI_Controller {

    public function registration(){
      $this->load->model('Bee', '', true);

      $id=isset($_POST['id']) ? $_POST['id'] : '';
      $pwd=isset($_POST['pwd']) ? $_POST['pwd'] : '';

      if($id!='' && $pwd!=''){
        $query=$this->Bee->registration($id, $this->_pwd_BCRYPT($pwd));

        if($query){
          $this->_JSONParsing(200, 'Success', '', '');
        } else {
          $this->_JSONParsing(303, 'ID is duplicated', '', '');
        }
      } else {
        $this->_JSONParsing(300, 'Parameter is invalid', '', '');
      }
    }

    public function login(){
      $this->load->model('Bee', '', true);

      $id=isset($_POST['id']) ? $_POST['id'] : '';
      $pwd=isset($_POST['pwd']) ? $_POST['pwd'] : '';

      if($id!='' && $pwd!=''){
        $query=$this->Bee->login($id);

        if(!$query){
          $this->_JSONParsing(305, 'No registered ID', '', '');

        } else {
          $row = $query->row();

          if($row->try > 4){
            $this->_JSONParsing(304, 'Exceeded login count', '', '');

          } else {
            if(password_verify($pwd, $row->user_pwd)){
              $this->Bee->pwdtry(true, $id);
              if($row->level < 1) {
                $this->_JSONParsing(401, 'Get permission from an administrator', '', '');

              } else if ($row->level == 99){
                $token=$this->Bee->publishtoken($row->id);
                $this->_JSONParsing(201, 'Admin Success','', $token);

              } else {
                $token=$this->Bee->publishtoken($row->id);
                $this->_JSONParsing(200, 'Success', '', $token);
              }


            } else{
              $this->Bee->pwdtry(false, $id);
              $this->_JSONParsing(302, 'Password error', '', '');

            }
          }
        }
      } else{
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
