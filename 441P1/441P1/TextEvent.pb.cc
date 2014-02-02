// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: TextEvent.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "TextEvent.pb.h"

#include <algorithm>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/stubs/once.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/generated_message_reflection.h>
#include <google/protobuf/reflection_ops.h>
#include <google/protobuf/wire_format.h>
// @@protoc_insertion_point(includes)

namespace {

const ::google::protobuf::Descriptor* TextEvent_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  TextEvent_reflection_ = NULL;
const ::google::protobuf::EnumDescriptor* EventType_descriptor_ = NULL;

}  // namespace


void protobuf_AssignDesc_TextEvent_2eproto() {
  protobuf_AddDesc_TextEvent_2eproto();
  const ::google::protobuf::FileDescriptor* file =
    ::google::protobuf::DescriptorPool::generated_pool()->FindFileByName(
      "TextEvent.proto");
  GOOGLE_CHECK(file != NULL);
  TextEvent_descriptor_ = file->message_type(0);
  static const int TextEvent_offsets_[5] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextEvent, text_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextEvent, location_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextEvent, user_id_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextEvent, type_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextEvent, delete__),
  };
  TextEvent_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      TextEvent_descriptor_,
      TextEvent::default_instance_,
      TextEvent_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextEvent, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextEvent, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(TextEvent));
  EventType_descriptor_ = file->enum_type(0);
}

namespace {

GOOGLE_PROTOBUF_DECLARE_ONCE(protobuf_AssignDescriptors_once_);
inline void protobuf_AssignDescriptorsOnce() {
  ::google::protobuf::GoogleOnceInit(&protobuf_AssignDescriptors_once_,
                 &protobuf_AssignDesc_TextEvent_2eproto);
}

void protobuf_RegisterTypes(const ::std::string&) {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    TextEvent_descriptor_, &TextEvent::default_instance());
}

}  // namespace

void protobuf_ShutdownFile_TextEvent_2eproto() {
  delete TextEvent::default_instance_;
  delete TextEvent_reflection_;
}

void protobuf_AddDesc_TextEvent_2eproto() {
  static bool already_here = false;
  if (already_here) return;
  already_here = true;
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
    "\n\017TextEvent.proto\"n\n\tTextEvent\022\014\n\004text\030\001"
    " \001(\t\022\020\n\010location\030\002 \001(\005\022\017\n\007user_id\030\003 \001(\003\022"
    " \n\004type\030\004 \001(\0162\n.EventType:\006INSERT\022\016\n\006del"
    "ete\030\005 \001(\010*7\n\tEventType\022\n\n\006INSERT\020\000\022\n\n\006DE"
    "LETE\020\001\022\010\n\004UNDO\020\002\022\010\n\004REDO\020\003", 186);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "TextEvent.proto", &protobuf_RegisterTypes);
  TextEvent::default_instance_ = new TextEvent();
  TextEvent::default_instance_->InitAsDefaultInstance();
  ::google::protobuf::internal::OnShutdown(&protobuf_ShutdownFile_TextEvent_2eproto);
}

// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer_TextEvent_2eproto {
  StaticDescriptorInitializer_TextEvent_2eproto() {
    protobuf_AddDesc_TextEvent_2eproto();
  }
} static_descriptor_initializer_TextEvent_2eproto_;
const ::google::protobuf::EnumDescriptor* EventType_descriptor() {
  protobuf_AssignDescriptorsOnce();
  return EventType_descriptor_;
}
bool EventType_IsValid(int value) {
  switch(value) {
    case 0:
    case 1:
    case 2:
    case 3:
      return true;
    default:
      return false;
  }
}


// ===================================================================

#ifndef _MSC_VER
const int TextEvent::kTextFieldNumber;
const int TextEvent::kLocationFieldNumber;
const int TextEvent::kUserIdFieldNumber;
const int TextEvent::kTypeFieldNumber;
const int TextEvent::kDeleteFieldNumber;
#endif  // !_MSC_VER

TextEvent::TextEvent()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void TextEvent::InitAsDefaultInstance() {
}

TextEvent::TextEvent(const TextEvent& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void TextEvent::SharedCtor() {
  _cached_size_ = 0;
  text_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  location_ = 0;
  user_id_ = GOOGLE_LONGLONG(0);
  type_ = 0;
  delete__ = false;
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

TextEvent::~TextEvent() {
  SharedDtor();
}

void TextEvent::SharedDtor() {
  if (text_ != &::google::protobuf::internal::kEmptyString) {
    delete text_;
  }
  if (this != default_instance_) {
  }
}

void TextEvent::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* TextEvent::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return TextEvent_descriptor_;
}

const TextEvent& TextEvent::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_TextEvent_2eproto();
  return *default_instance_;
}

TextEvent* TextEvent::default_instance_ = NULL;

TextEvent* TextEvent::New() const {
  return new TextEvent;
}

void TextEvent::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (has_text()) {
      if (text_ != &::google::protobuf::internal::kEmptyString) {
        text_->clear();
      }
    }
    location_ = 0;
    user_id_ = GOOGLE_LONGLONG(0);
    type_ = 0;
    delete__ = false;
  }
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool TextEvent::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // optional string text = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_text()));
          ::google::protobuf::internal::WireFormat::VerifyUTF8String(
            this->text().data(), this->text().length(),
            ::google::protobuf::internal::WireFormat::PARSE);
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(16)) goto parse_location;
        break;
      }

      // optional int32 location = 2;
      case 2: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_location:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &location_)));
          set_has_location();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(24)) goto parse_user_id;
        break;
      }

      // optional int64 user_id = 3;
      case 3: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_user_id:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int64, ::google::protobuf::internal::WireFormatLite::TYPE_INT64>(
                 input, &user_id_)));
          set_has_user_id();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(32)) goto parse_type;
        break;
      }

      // optional .EventType type = 4 [default = INSERT];
      case 4: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_type:
          int value;
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   int, ::google::protobuf::internal::WireFormatLite::TYPE_ENUM>(
                 input, &value)));
          if (::EventType_IsValid(value)) {
            set_type(static_cast< ::EventType >(value));
          } else {
            mutable_unknown_fields()->AddVarint(4, value);
          }
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(40)) goto parse_delete;
        break;
      }

      // optional bool delete = 5;
      case 5: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_delete:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   bool, ::google::protobuf::internal::WireFormatLite::TYPE_BOOL>(
                 input, &delete__)));
          set_has_delete_();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectAtEnd()) return true;
        break;
      }

      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void TextEvent::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // optional string text = 1;
  if (has_text()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->text().data(), this->text().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    ::google::protobuf::internal::WireFormatLite::WriteString(
      1, this->text(), output);
  }

  // optional int32 location = 2;
  if (has_location()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(2, this->location(), output);
  }

  // optional int64 user_id = 3;
  if (has_user_id()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt64(3, this->user_id(), output);
  }

  // optional .EventType type = 4 [default = INSERT];
  if (has_type()) {
    ::google::protobuf::internal::WireFormatLite::WriteEnum(
      4, this->type(), output);
  }

  // optional bool delete = 5;
  if (has_delete_()) {
    ::google::protobuf::internal::WireFormatLite::WriteBool(5, this->delete_(), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* TextEvent::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // optional string text = 1;
  if (has_text()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->text().data(), this->text().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        1, this->text(), target);
  }

  // optional int32 location = 2;
  if (has_location()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(2, this->location(), target);
  }

  // optional int64 user_id = 3;
  if (has_user_id()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArray(3, this->user_id(), target);
  }

  // optional .EventType type = 4 [default = INSERT];
  if (has_type()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteEnumToArray(
      4, this->type(), target);
  }

  // optional bool delete = 5;
  if (has_delete_()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteBoolToArray(5, this->delete_(), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int TextEvent::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // optional string text = 1;
    if (has_text()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::StringSize(
          this->text());
    }

    // optional int32 location = 2;
    if (has_location()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->location());
    }

    // optional int64 user_id = 3;
    if (has_user_id()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int64Size(
          this->user_id());
    }

    // optional .EventType type = 4 [default = INSERT];
    if (has_type()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::EnumSize(this->type());
    }

    // optional bool delete = 5;
    if (has_delete_()) {
      total_size += 1 + 1;
    }

  }
  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = total_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void TextEvent::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const TextEvent* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const TextEvent*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void TextEvent::MergeFrom(const TextEvent& from) {
  GOOGLE_CHECK_NE(&from, this);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_text()) {
      set_text(from.text());
    }
    if (from.has_location()) {
      set_location(from.location());
    }
    if (from.has_user_id()) {
      set_user_id(from.user_id());
    }
    if (from.has_type()) {
      set_type(from.type());
    }
    if (from.has_delete_()) {
      set_delete_(from.delete_());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void TextEvent::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void TextEvent::CopyFrom(const TextEvent& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool TextEvent::IsInitialized() const {

  return true;
}

void TextEvent::Swap(TextEvent* other) {
  if (other != this) {
    std::swap(text_, other->text_);
    std::swap(location_, other->location_);
    std::swap(user_id_, other->user_id_);
    std::swap(type_, other->type_);
    std::swap(delete__, other->delete__);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata TextEvent::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = TextEvent_descriptor_;
  metadata.reflection = TextEvent_reflection_;
  return metadata;
}


// @@protoc_insertion_point(namespace_scope)

// @@protoc_insertion_point(global_scope)
