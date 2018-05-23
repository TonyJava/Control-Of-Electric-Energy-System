<?php
  defined('BASEPATH') OR exit('No direct script access allowed');

  class Shutdown extends CI_Controller {

    public function askdb(){
      $this->load->model('Bee', '', true);

      $token=isset($_POST['token']) ? $_POST['token'] : '';
      $building=isset($_POST['building']) ? $_POST['building'] : '';

      if($token!='' && $building!=''){
        $query=$this->Bee->chktoken($token);

        if($query){
            $newToken=$this->Bee->publishtoken($query->row()->users_id);
            $result = $this->Bee->askdb($building);
            $this->_JSONParsing(200, 'Success', $result, $newToken);

        } else{
          $this->_JSONParsing(305, 'Your token has expired.', '', '');
        }
      } else{
        $this->_JSONParsing(300, 'Parameter is invalid', '', '');
      }
    }

    public function turnoff(){
      $this->load->model('Bee', '', true);

      $token=isset($_POST['token']) ? $_POST['token'] : '';
      $location=isset($_POST['location']) ? $_POST['location'] : '';

      if($token!='' && $location!=''){
        $query=$this->Bee->chktoken($token);
        $row=$query->row();

        if($query){
            $newToken=$this->Bee->publishtoken($query->row()->users_id);
            $this->Bee->turnoff($location);
            $this->Bee->offlog($row->users_id, $location);
            $this->_JSONParsing(200, 'Success', '', $newToken);

        } else {
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
