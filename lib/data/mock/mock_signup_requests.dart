import '../../models/signup_request.dart';

const mockSignupRequests = [
  SignupRequest(
    id: 'sol-001',
    establishmentName: 'Barraca Sol Nascente',
    ownerName: 'Marcos Silva',
    phone: '(81) 99999-1001',
    address: 'Boa Viagem, proximo ao posto 6',
    notes: 'Quer aparecer na lista publica do MVP.',
    status: SignupRequestStatus.pending,
  ),
  SignupRequest(
    id: 'sol-002',
    establishmentName: 'Praia Boa Drinks',
    ownerName: 'Renata Alves',
    phone: '(81) 98888-2002',
    address: 'Faixa de areia, trecho norte',
    notes: 'Tem cardapio de drinks e petiscos.',
    status: SignupRequestStatus.pending,
  ),
  SignupRequest(
    id: 'sol-003',
    establishmentName: 'Recife Mar Bar',
    ownerName: 'Joao Batista',
    phone: '(81) 97777-3003',
    address: 'Av. Boa Viagem, trecho central',
    notes: 'Solicitacao ja analisada no mock.',
    status: SignupRequestStatus.approved,
  ),
];
